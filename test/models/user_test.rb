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

require 'test_helper'
class UserTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  test 'user is valid with all atributes' do
    WebStub.stub_sendgrid_validator
    user = User.new(email: 'miguel@michelada.io',
                    password: 'Password1',
                    first_name: 'Miguel ',
                    last_name: 'Urbina')

    assert user.valid?
  end

  test 'referral code is auto-generated on registration' do
    WebStub.stub_sendgrid_validator
    WebStub.stub_sendgrid_contacts
    User.any_instance.stubs(:registry_twilio_user).returns(true)
    user = User.new(email: 'miguel@michelada.io',
                    password: 'Password1',
                    first_name: 'Miguel ',
                    last_name: 'Urbina')

    user.save

    refute user.referral_code.blank?
  end

  test 'user is not valid with no email' do
    WebStub.stub_sendgrid_validator
    user = User.new(password: 'Password1',
                    first_name: 'Miguel Urbina')

    refute user.valid?
  end

  test 'user is valid without password' do
    WebStub.stub_sendgrid_validator
    user = User.new(email: 'miguel@michelada.io',
                    first_name: 'Miguel Urbina')

    assert user.valid?
  end

  test 'user is not valid with invalid password' do
    WebStub.stub_sendgrid_validator
    user = User.new(email: 'miguel@michelada.io',
                    password: 'Password',
                    first_name: 'Miguel Urbina')

    refute user.valid?
  end

  test 'user is not valid with number_license less than 8 characters length' do
    WebStub.stub_sendgrid_validator
    user = User.new(email: 'miguel@michelada.io',
                    password: 'Password1',
                    first_name: 'Miguel ',
                    last_name: 'Urbina',
                    number_license: '1234567')

    refute user.valid?
  end

  test 'user is not valid with number_license more than 8 characters length' do
    WebStub.stub_sendgrid_validator
    user = User.new(email: 'miguel@michelada.io',
                    password: 'Password1',
                    first_name: 'Miguel ',
                    last_name: 'Urbina',
                    number_license: '123456789')

    refute user.valid?
  end

  test 'test_finished? returns false when user has no completed the personal test' do
    user = users(:user_without_responses)
    refute user.test_finished?
  end

  test 'test_finised? returns true when user has finished the personal test ' do
    user = users(:user_without_responses)
    LiveFactor.all.each do |live_factor|
      user.responses.create(live_factor: live_factor, response: 0)
    end

    assert user.test_finished?
  end

  test 'personal test progress is 0 when use has no one reponse' do
    user = users(:user_without_responses)
    assert_equal 0, user.personal_test_resposes_number
  end

  test 'personal test responses is 2 when user has responded all live factors' do
    user = users(:user_without_responses)
    LiveFactor.all.each do |live_factor|
      user.responses.create(live_factor: live_factor, response: 0)
    end

    assert_equal 2, user.personal_test_resposes_number
  end

  test 'it creates an activity when its referred' do
    referrer = users(:user_without_responses)
    WebStub.stub_sendgrid_validator
    WebStub.stub_sendgrid_contacts
    User.any_instance.stubs(:registry_twilio_user).returns(true)
    user = User.new(email: 'miguel@michelada.io',
                    password: 'Password1',
                    first_name: 'Miguel ',
                    last_name: 'Urbina',
                    invited_by: referrer)

    assert_difference 'PublicActivity::Activity.count', 2 do
      user.save
    end
  end

  test 'profile is completed if it has name and image' do
    user = users(:verified_user)

    assert user.profile_completed?
  end

  test 'profile is not completed if it doesnt have image' do
    user = users(:user_without_role)

    refute user.profile_completed?
  end

  test 'profile is not completed if it has no name' do
    user = users(:co_borrower_user)
    user.update!(first_name: nil)

    refute user.profile_completed?
  end

  test 'notifications settings is created when saving user' do
    WebStub.stub_sendgrid_validator
    User.any_instance.stubs(:registry_twilio_user).returns(true)

    assert_difference 'NotificationSettings.count', 1 do
      User.create(email: 'sample_user@example.com', role: :agent, password: 'Password1')
    end
  end

  test 'new user without name has default slug as email' do
    User.any_instance.stubs(:registry_twilio_user).returns(true)
    user = User.create(email: 'michael_black@gmail.com',
                       password: 'Password1')

    assert_equal user.email.parameterize, user.slug
  end

  test 'user who updates name has slug with his name' do
    User.any_instance.stubs(:registry_twilio_user).returns(true)
    user = User.create(email: 'michael_black@gmail.com',
                       password: 'Password1')
    user.update(first_name: 'Michael', last_name: 'Black')

    refute_equal user.email.parameterize, user.slug
    assert_equal user.full_name.parameterize, user.slug
  end

  test 'user with a slug repeated is created with id' do
    User.any_instance.stubs(:registry_twilio_user).returns(true)
    co_borrower_user = users(:co_borrower_user)
    user = User.create(email: 'michael_black@gmail.com', password: 'Password1')

    refute_equal user.slug, co_borrower_user.slug

    user.update(first_name: co_borrower_user.first_name, last_name: co_borrower_user.last_name)

    refute_equal user.slug, co_borrower_user.slug
  end

  test 'sends email to sales team and agents with area when user sets its city' do
    user = User.create(email: 'michael_black@gmail.com', password: 'Password1', role: :co_borrower)

    user.update(city: 'Santa Monica')

    assert_enqueued_emails 4
  end
end
