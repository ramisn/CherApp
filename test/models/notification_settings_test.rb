# frozen_string_literal: true

# == Schema Information
#
# Table name: notification_settings
#
#  id             :bigint           not null, primary key
#  user_id        :bigint
#  accept_email   :boolean          default("true")
#  accept_sms     :boolean          default("true")
#  account        :boolean          default("true")
#  social_network :boolean          default("true")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'test_helper'

class NotificationSettingsTest < ActiveSupport::TestCase
  test 'it is not valid without a user' do
    settings = NotificationSettings.new

    refute settings.valid?
    assert settings.errors[:user]
  end

  test 'it is valid with a user' do
    settings = NotificationSettings.new(user: users(:co_borrower_user))

    assert settings.valid?
  end
end
