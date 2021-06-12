# frozen_string_literal: true

# == Schema Information
#
# Table name: prospects
#
#  id                    :bigint           not null, primary key
#  email                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  is_subscribed         :boolean          default("true"), not null
#  marked_as_spam        :boolean          default("false"), not null
#  bounced               :boolean          default("false"), not null
#  role                  :integer          default("0")
#  first_name            :string
#  city                  :string
#  mailchimp_updated_at  :datetime
#  mailchimp_sync_status :integer          default("0")
#  phone_number          :string
#  last_name             :string
#

class Prospect < ApplicationRecord
  include Discard::Model

  include PgSearch::Model
  VALID_EMAIL_REGEX = /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/.freeze
  VALID_PHONE_NUMBER_REGEX = /\d{10}/.freeze
  LETTER_MAPPING = { '1': :prospect,
                     '2': :user,
                     '3': :seller,
                     '4': :landlord,
                     '5': :tenant,
                     '6': :loan_officer,
                     '7': :escrow_officer,
                     '8': :general_contractor,
                     '9': :mortgage_broker,
                     '10': :other_rep,
                     '11': :customer_other,
                     '12': :real_estate_agent,
                     '13': :subscriber }.freeze

  has_one :contact, as: :contactable

  enum role: %i[subscriber
                prospect
                user customer_other
                general_contractor
                loan_officer
                mortgage_broker
                realtor
                title_officer
                escrow_officer
                other_rep
                seller
                landlord
                tenant
                real_estate_agent]
  enum mailchimp_sync_status: %i[mailchimp_pending mailchimp_sync mailchimp_archived]

  attr_accessor :skip_sync

  validates :email, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }, allow_nil: true
  validates :phone_number, uniqueness: true, format: { with: VALID_PHONE_NUMBER_REGEX }, allow_nil: true

  multisearchable against: %i[first_name last_name email phone_number]

  scope :by_search, ->(text) { where(id: PgSearch.multisearch(text).pluck(:searchable_id)) }
  scope :with_name, -> { where.not(first_name: nil) }

  before_create do
    self.email = email.downcase if email
  end

  after_create :create_contact
  # after_create :move_to_mailchimp
  # after_update :update_in_mailchimp, if: proc { |p| p.role_previously_changed? }

  def type
    role
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def create_contact
    return unless lookup_contact.nil?

    status = is_subscribed ? :created : :unsubscribe
    contact = build_contact(status: status)
    contact.save
  end

  def lookup_contact
    contact = Contact.lookup(email)
    # update_in_mailchimp if contact&.contactable && role_previously_changed?
    contact
  end

  def move_to_mailchimp
    return if skip_sync

    # RegisterContactmailchimpJob.perform_later(email, "prospect_#{role}".to_sym)
    AddToMailchimpJob.perform_later(email, "prospect_#{role}")
    mailchimp_updated!
  end

  def update_in_mailchimp
    TagMailchimpJob.perform_later(email, "prospect_#{role_previous_change.first}", 'inactive')
    TagMailchimpJob.perform_later(email, "prospect_#{role}")
  end

  def mailchimp_updated!
    mailchimp_sync!
    touch(:mailchimp_updated_at)
  end

  def mailchimp_removed!
    mailchimp_archived!
    touch(:mailchimp_updated_at)
  end
end
