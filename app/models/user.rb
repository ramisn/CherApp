# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                          :bigint           not null, primary key
#  email                       :string           default(""), not null
#  encrypted_password          :string           default(""), not null
#  reset_password_token        :string
#  reset_password_sent_at      :datetime
#  remember_created_at         :datetime
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  provider                    :string
#  uid                         :string
#  first_name                  :string
#  image                       :text
#  role                        :integer
#  score                       :integer
#  confirmation_token          :string
#  confirmed_at                :datetime
#  confirmation_sent_at        :datetime
#  verification_type           :string
#  discarded_at                :datetime
#  last_question_reponded      :string
#  last_name                   :string
#  test_attempts               :integer          default("0"), not null
#  test_blocked_till           :date
#  test_reset_period           :date
#  search_history              :string           default("{}"), is an Array
#  search_intent               :string
#  invitation_token            :string
#  invitation_created_at       :datetime
#  invitation_sent_at          :datetime
#  invitation_accepted_at      :datetime
#  invitation_limit            :integer
#  invited_by_type             :string
#  invited_by_id               :bigint
#  invitations_count           :integer          default("0")
#  needs_verification          :boolean          default("false"), not null
#  accept_terms_and_conditions :boolean          default("true"), not null
#  accept_privacy_policy       :boolean          default("true"), not null
#  accept_referral_agreement   :boolean          default("false")
#  sell_my_info                :boolean          default("true"), not null
#  description                 :string
#  company_name                :string
#  address1                    :string
#  areas                       :string           default("{}"), is an Array
#  status                      :integer          default("0"), not null
#  address2                    :string
#  number_license              :string
#  city                        :string
#  state                       :string
#  zipcode                     :string
#  professional_role           :integer
#  specialties                 :string           default("{}"), is an Array
#  proffesional_verfied        :boolean          default("false")
#  funding                     :integer
#  co_borrowers                :integer
#  end_of_clique               :date
#  plan_type                   :string
#  contact_professional        :boolean          default("false"), not null
#  referral_code               :string
#  discard_token               :string
#  phone_number                :string
#  mailchimp_updated_at        :datetime
#  mailchimp_sync_status       :integer          default("0")
#  skip_onbording              :boolean          default("false"), not null
#  background_check_status     :integer          default("0")
#  middle_name                 :string
#  date_of_birth               :date
#  slug                        :string           default(""), not null
#  ssn                         :string
#  used_promo_codes            :string           default("{}"), is an Array
#  message_credits             :integer          default("0"), not null
#  feedback_plan_step          :integer          default("0")
#  uuid                        :uuid             not null
#  track_share_a_sale          :boolean
#  last_seen_at                :datetime
#  gender                      :integer
#  property_type               :integer
#  budget_from                 :integer
#  budget_to                   :integer
#

class User < ApplicationRecord
  include Discard::Model
  include PgSearch::Model
  include PublicActivity::Model
  tracked only: :create, owner: proc { |_controller, model| model }

  devise :database_authenticatable, :invitable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :confirmable,
         omniauth_providers: %i[facebook linkedin google_oauth2]

  has_and_belongs_to_many :promo_codes
  has_many :activities_as_owner, as: :owner, class_name: 'PublicActivity::Activity', dependent: :destroy
  has_many :activities_as_recipient, as: :recipient, class_name: 'PublicActivity::Activity', dependent: :destroy
  has_many :flagged_properties, dependent: :destroy
  has_many :friend_request_received, class_name: 'FriendRequest', foreign_key: 'requestee_id', dependent: :destroy
  has_many :friend_request_sent, class_name: 'FriendRequest', foreign_key: 'requester_id', dependent: :destroy
  has_many :houses, class_name: 'House', foreign_key: 'owner_id', dependent: :destroy
  has_many :loan_participants
  has_many :loans, through: :loan_participants
  has_many :notifications, class_name: 'Notification', foreign_key: 'owner_id', dependent: :destroy
  has_many :professional_reviews, -> { order(created_at: :desc) }, foreign_key: 'reviewed_id'
  has_many :publications, class_name: 'Publication', foreign_key: 'owner_id', dependent: :destroy
  has_many :publications_received, class_name: 'Publication', foreign_key: 'recipient_id', dependent: :destroy
  has_many :received_notifications, class_name: 'Notification', foreign_key: 'recipient_id', dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :rentals, class_name: 'Rental', foreign_key: 'owner_id', dependent: :destroy
  has_many :property_searches, dependent: :destroy
  has_many :requested_loans, class_name: 'Loan', foreign_key: 'user_id'
  has_many :seen_properties, dependent: :destroy
  has_many :shapes, dependent: :destroy
  has_one :contact, as: :contactable, dependent: :destroy
  has_one :notification_settings, dependent: :destroy
  has_one :lead
  has_one_attached :image_stored
  has_one_attached :blurred_image
  has_many_attached :images

  accepts_nested_attributes_for :responses, reject_if: proc { |attributes| attributes['response'].blank? }
  delegate :accept_notification?, to: :notification_settings, allow_nil: true
  attr_accessor :skip_mailchimp_verification

  validates :first_name, allow_blank: true, length: { in: 3..40 }
  validates :last_name, allow_blank: true,  length: { in: 3..40 }
  validates :image_stored, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 10.megabytes }
  validates :number_license, length: { is: 8 }, unless: ->(user) { user.number_license.blank? }
  validates :images, content_type: ['image/png', 'image/jpg', 'image/jpeg'], limit: { max: 4 }
  validates :funding, numericality: { only_integer: true }, unless: proc { |u| u.funding.blank? }
  validates :phone_number, allow_blank: true, length: { in: 10..13 }
  validate :password_complexity
  validates_associated :property_searches
  validates_numericality_of :budget_to, allow_blank: true, greater_than: :budget_from

  LETTER_MAPPING = { '14': :user,
                     '15': :seller, # Not implemented
                     '16': :landlord, # Not implemented
                     '17': :tenant, # Not implemented
                     '18': :loan_officer,
                     '19': :escrow_officer,
                     '20': :general_contractor,
                     '21': :mortgage_broker,
                     '22': :title_officer,
                     '23': :other,
                     '24': :estate_agent,
                     '25': :agent_clique }.freeze # Not implemented

  enum role: %i[co_borrower agent admin]
  enum property_type: %i[house condo mobile multifamily]
  enum gender: %i[male female]
  enum status: %i[looking ready process closing]
  enum professional_role: %i[estate_agent loan_officer escrow_officer general_contractor mortgage_broker title_officer other]
  enum mailchimp_sync_status: %i[mailchimp_pending mailchimp_sync mailchimp_archived]
  enum background_check_status: %i[no_requested pending approved rejected]
  enum feedback_plan_step: %i[first_ask first_follow_up second_follow_up gift_card last_round finished_plan]

  multisearchable against: %i[first_name last_name email phone_number]

  scope :buyers, ->(city, user_id) { where("'#{city.downcase}' = ANY (search_history)").where.not(id: user_id).uniq }
  scope :find_first_five_matches, lambda { |current_user_id, text|
                                    public_users(current_user_id).by_search(text).limit(5)
                                  }
  scope :by_search, ->(text) { where(id: PgSearch.multisearch(text).pluck(:searchable_id)) }
  scope :by_provider, ->(provider, uids) { where(uid: uids, provider: provider) }
  scope :by_emails, ->(emails) { where(email: emails) }
  scope :by_city, ->(city) { where('lower(city) LIKE ?', "%#{city&.downcase}%") }
  scope :in_area, ->(cities) { where(city: cities) }
  scope :by_area, ->(area) { where('? ILIKE ANY(areas)', area) }
  scope :not_current, ->(user_id) { where.not(id: user_id) }
  scope :not_in_collection, ->(users_ids) { where.not(id: users_ids) }
  scope :public_users, ->(user_id) { where.not(id: user_id).where.not(role: :admin).where.not(role: nil) }
  scope :inside_feedback_plan, -> { where.not(feedback_plan_step: :finished_plan) }
  scope :with_clique, -> { where('end_of_clique > ?', Date.today) }
  scope :with_background_checked, -> { where(background_check_status: 'approved') }
  scope :with_funding, -> { where.not(funding: nil) }
  scope :with_id_validation, -> { where.not(verification_type: nil) }
  scope :with_name, -> { where.not(first_name: nil) }
  scope :with_profile, -> { where.not(role: :admin) }
  scope :with_role, ->(role) { where(role: role) }
  scope :created_ago, ->(time) { where('created_at <= ?', time) }
  scope :created_from, ->(time) { where('created_at >= ?', time) }
  scope :with_feedback_plan_on, ->(step) { where(feedback_plan_step: step) }
  scope :suggested_matches, lambda { |current_user|
                              public_users(current_user.id)
                                .co_borrower
                                .not_in_collection(current_user.friends)
                                .select(&:profile_completed?)
                            }
  scope :suggested_matches_agent, lambda { |current_user|
                                    public_users(current_user.id)
                                      .agent
                                      .not_in_collection(current_user.friends)
                                      .select(&:profile_completed?)
                                  }
  scope :suggested_leads, lambda { |current_user|
                            public_users(current_user.id)
                              .co_borrower
                              .with_name
                              .not_in_collection(current_user.friends)
                              .order(created_at: :desc)
                              .order(:city, :first_name, :last_name)
                          }
  scope :concierge_contact, -> { find_by(email: ENV['CONCIERGE_CHAT_EMAIL']) }

  after_create :set_referral_code, :create_notification_settings, :create_contact,
               :registry_twilio_user, :notify_user, :create_notification
  after_create :registry_referral_activity, if: proc { invited_by }
  before_create :set_email_slug
  before_save :set_slug, if: proc { first_name_changed? || last_name_changed? || email_changed? }
  before_update :notify_cher_team, if: proc { (city_was.nil? && city_changed?) && role_was.present? && co_borrower? }
  after_invitation_created :track_user_invitation
  after_save :salesforce_lead_create, if: :saved_change_to_last_name?

  def active_for_authentication?
    super && !discarded?
  end

  def blocked?
    return unless test_blocked_till

    test_blocked_till > Date.today
  end

  def contact_professional_progress_status
    return :pending if friends_progress_status != :completed

    contact_professional ? :completed : :active
  end

  def create_notification
    notifications.create!(recipient: self, key: 'account_confirmation') unless confirmed_at.blank?
    notifications.create!(recipient: self, key: 'complete_profile')
  end

  def create_notification_settings
    create_notification_settings!(preferences: { flagged_home_email: 0, flagged_home_sms: 0 })
  end

  def flag_property_progress_status
    flagged_properties.any? ? :completed : :active
  end

  def flagged_properties_data
    properties_ids = flagged_properties.pluck(:property_id)
    return properties_ids unless properties_ids.any?

    SimplyRets.find_properties_by_ids(properties_ids)
  end

  def latest_flagged_properties
    properties_ids = flagged_properties.order(created_at: :desc).limit(4).pluck(:property_id)
    return properties_ids unless properties_ids.any?

    SimplyRets.find_properties_by_ids(properties_ids)
  end

  def friends
    friends_requested.union(friends_accepted)
  end

  def friends_accepted
    FriendRequest.request_accepted(id).map(&:requester)
  end

  def friends_progress_status
    return :pending if flag_property_progress_status == :active

    friends.any? ? :completed : :active
  end

  def friends_requested
    FriendRequest.request_requested(id).map(&:requestee)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def last_notifications
    received_notifications.order(created_at: :desc).limit(10)
  end

  def friend_request_pending?
    friend_request_received.where(status: :pending).any?
  end

  def local_knowledge_avg
    @local_knowledge_avg ||= professional_reviews.average(:local_knowledge)
  end

  def negotiation_skills_avg
    @negotiation_skills_avg ||= professional_reviews.average(:negotiation_skills)
  end

  def notify_user
    WelcomeUserNotifierService.new(self).execute unless role.blank?
  end

  def number_of_friend_requests_pending
    @number_of_friend_requests_pending ||= friend_request_received.where(status: :pending).count
  end

  def part_of_clique?
    end_of_clique && end_of_clique > Date.today
  end

  def password_complexity
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,70}$/

    errors.add :password, I18n.t('.password_complexity_error')
  end

  def personal_test_resposes_number
    responses.count
  end

  def profile_image
    return image_stored if image_stored.attached?

    image || 'cherapp-ownership-coborrowing-ico-user.svg'
  end

  def profile_completed?
    !first_name.blank? && (image_stored.attached? || !image.blank?)
  end

  def profile_fulfilled?
    test_finished? && validated?
  end

  def provider_name
    provider.blank? ? 'Organic' : I18n.t("providers.#{provider}")
  end

  def process_expertise_avg
    @process_expertise_avg ||= professional_reviews.average(:process_expertise)
  end

  def responsiveness_avg
    @responsiveness_avg ||= professional_reviews.average(:responsiveness)
  end

  def reviews_avg
    return 0 unless professional_reviews.any?

    (responsiveness_avg + process_expertise_avg + local_knowledge_avg + negotiation_skills_avg) / 4
  end

  def general_role_name
    if co_borrower?
      I18n.t('roles.coowner')
    elsif agent?
      I18n.t("professional_roles.#{professional_role}")
    else
      ''
    end
  end

  def set_referral_code
    update(referral_code: Devise.friendly_token(50))
  end

  def registry_referral_activity
    create_activity key: 'user.referred', recipient: invited_by
  end

  def registry_twilio_user
    RegistryTwilioUserJob.perform_later(email)
  end

  def test_finished?
    personal_test_resposes_number == LiveFactor.number_of_questions
  end

  def track_registration_event(mixpanel_data)
    return unless Rails.env.production? || Rails.env.staging?

    GoogleAnalytics.track_new_user(self) if Rails.env.production?
    MixpanelTracker.setup_user(self, mixpanel_data)
    MixpanelTracker.track_sign_up(self, mixpanel_data)
    MixpanelTracker.track_log_in(self, mixpanel_data['$ip']) if mixpanel_data && mixpanel_data['$ip']
  end

  def validated?
    verification_type.present?
  end

  def zero_closing_progress_status
    contact_professional_progress_status == :completed ? :active : :pending
  end

  def type
    if professional_role.nil?
      :user
    else
      professional_role.to_sym
    end
  end

  def track_user_invitation
    MixpanelTracker.track_event(invited_by.email, 'Invited someone', invited: email)
  end

  def create_contact
    Contact.find_or_create_by_prospect(email: email, role: 'user')
  end

  def mailchimp_updated!
    mailchimp_sync!
    touch(:mailchimp_updated_at)
  end

  def mailchimp_removed!
    mailchimp_archived!
    touch(:mailchimp_updated_at)
  end

  def update_contact
    contact = Contact.lookup(email)

    if contact&.contactable
      prospect = contact&.contactable
      TagMailchimpJob.perform_later(email, "prospect_#{prospect.type}", 'inactive')
      prospect&.delete
      contact.delete
    end

    contact = build_contact
    contact.save

    # TagMailchimpJob.perform_later(email, type.to_s)

    # mailchimp_updated!
  end

  def flagged?(property_id)
    flagged_properties.where(property_id: property_id).exists?
  end

  def base_city
    city || flagged_properties.where("city != ''").first&.city
  end

  def set_email_slug
    self.slug = email.parameterize
  end

  def set_slug
    slug = full_name.blank? ? email.parameterize : full_name.parameterize
    self.slug = User.unscoped.find_by(slug: slug) ? slug + id.to_s : slug
  end

  def to_param
    slug
  end

  def active_loan_request
    requested_loans.active.first || requested_loans.waiting.first
  end

  def password_required?
    false
  end

  def can_start_conversation?
    return true unless agent?

    message_credits.positive?
  end

  def use_message_credit
    update(message_credits: message_credits - 1)
  end

  def verified?
    validated? && background_check_status == :approved
  end

  def external_attendee_name
    first_name.blank? ? email : slug
  end

  def notify_cher_team
    params = { first_name: first_name, email: email, agent: agent?, city: city, slug: slug }
    NotifyNewUserService.new(params).execute
  end

  def recently_active?
    return false unless last_seen_at

    last_seen_at > 30.minutes.ago
  end

  def accepts_property_notification?(property_id)
    notification_settings.accept_type_notification?("property_#{property_id}")
  end

  # Salforce Lead cteating from CherApp
  def salesforce_lead_create
    user = User.select("first_name, last_name").last
    SalesforceLeadJob.perform_later(email) if (user.last_name).present?
  end

  def self.search_keyword(search_by, keyword)
    case search_by
    when "name"
      where("LOWER(users.first_name) LIKE :keyword OR
             LOWER(users.last_name) LIKE :keyword", {:keyword => "%#{keyword.downcase}%"})
    when "email"
      where("LOWER(users.email) LIKE :keyword", {:keyword => "%#{keyword.downcase}%"})
    when "city"
      by_city(keyword)
    else
      "Do nothing..."
    end
  end
end
