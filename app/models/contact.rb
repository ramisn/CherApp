# frozen_string_literal: true

# == Schema Information
#
# Table name: contacts
#
#  id               :bigint           not null, primary key
#  status           :integer          default("0")
#  contactable_id   :integer
#  contactable_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Contact < ApplicationRecord
  include Discard::Model

  belongs_to :contactable, polymorphic: true

  delegate :email, :role, :mailchimp_sync_status, :mailchimp_updated_at, to: :contactable

  enum status: %i[created dropped deferred bounce blocked spamreport unsubscribe groupunsubscribe risky]

  UNSUBSCRIBE_EVENTS = %i[dropped deferred bounce blocked unsubscribe groupunsubscribe risky].freeze

  LETTER_MAPPING = { A: :created, B: :dropped, C: :deferred, D: :bounce, E: :blocked, F: :spamreport, G: :unsubscribe, H: :groupunsubscribe }.freeze

  US_STATES = [
    ['Alabama', 'AL'], ['Alaska', 'AK'], ['Arizona', 'AZ'], ['Arkansas', 'AR'], ['California', 'CA'], ['Colorado', 'CO'], ['Connecticut', 'CT'], ['Delaware', 'DE'], ['District of Columbia', 'DC'], ['Florida', 'FL'], ['Georgia', 'GA'], ['Hawaii', 'HI'], ['Idaho', 'ID'], ['Illinois', 'IL'], ['Indiana', 'IN'], ['Iowa', 'IA'], ['Kansas', 'KS'], ['Kentucky', 'KY'], ['Louisiana', 'LA'], ['Maine', 'ME'], ['Maryland', 'MD'], ['Massachusetts', 'MA'], ['Michigan', 'MI'], ['Minnesota', 'MN'], ['Mississippi', 'MS'], ['Missouri', 'MO'], ['Montana', 'MT'], ['Nebraska', 'NE'], ['Nevada', 'NV'], ['New Hampshire', 'NH'], ['New Jersey', 'NJ'], ['New Mexico', 'NM'], ['New York', 'NY'], ['North Carolina', 'NC'], ['North Dakota', 'ND'], ['Ohio', 'OH'], ['Oklahoma', 'OK'], ['Oregon', 'OR'], ['Pennsylvania', 'PA'], ['Puerto Rico', 'PR'], ['Rhode Island', 'RI'], ['South Carolina', 'SC'], ['South Dakota', 'SD'], ['Tennessee', 'TN'], ['Texas', 'TX'], ['Utah', 'UT'], ['Vermont', 'VT'], ['Virginia', 'VA'], ['Washington', 'WA'], ['West Virginia', 'WV'], ['Wisconsin', 'WI'], ['Wyoming', 'WY']
  ]

  def self.find_or_create_by_prospect(prospect)
    prospect_record = Prospect.where(email: prospect[:email]).first_or_initialize
    prospect_record.role = prospect[:role] || 'prospect'
    prospect_record.first_name = prospect[:first_name]
    prospect_record.city = prospect[:city]
    prospect_record.skip_sync = prospect[:skip_sync]

    return unless prospect_record.save

    Contact.where(contactable: prospect_record).first_or_create do |contact|
      contact.status = prospect[:status]
    end
  end

  def self.lookup(email)
    user(email) || prospect(email)
  end

  def self.user(email)
    User.includes(:contact).where(email: email).first&.contact
  end

  def self.prospect(email)
    Prospect.includes(:contact).where(email: email).first&.contact
  end

  def self.users_by_type(type)
    role = User::LETTER_MAPPING[type.to_sym]
    if role == :user
      User.includes(:contact).where(role: :co_borrower)
    else
      User.includes(:contact).where(professional_role: role.to_s)
    end
  end

  def self.prospect_by_type(type)
    role = Prospect::LETTER_MAPPING[type.to_sym]
    Prospect.includes(:contact).where(role: role.to_s)
  end

  def self.by_type(type)
    if type.to_i > 13
      users_by_type(type)
    else
      prospect_by_type(type)
    end
  end

  def self.all_roles
    (Prospect.roles.keys.map { |c| 'prospect_' + c } << User.professional_roles.keys << 'user').flatten
  end

  def type
    contactable_type
  end

  def role
    if contactable_type == 'Prospect'
      'prospect_' + contactable.type
    else
      contactable.type
    end
  end

  def condition
    number_key = Prospect::LETTER_MAPPING
    number_key = User::LETTER_MAPPING if contactable_type != 'Prospect'

    LETTER_MAPPING.invert[status.to_sym].to_s + number_key.invert[contactable.type.to_sym].to_s
  end

  def self.in_mailchimp
    User.where(mailchimp_sync_status: :mailchimp_sync) + Prospect.where(mailchimp_sync_status: :mailchimp_sync)
  end

  def self.by_search(search)
    users_ids = User.by_search(search).pluck(:id)
    prospects_ids = Prospect.by_search(search).pluck(:id)

    Contact.where(contactable_type: 'User', contactable_id: users_ids)
           .or(Contact.where(contactable_type: 'Prospect', contactable_id: prospects_ids))
           .kept
  end
end
