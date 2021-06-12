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
class NotificationSettings < ApplicationRecord
  belongs_to :user

  def accept_notification?(type:, method:)
    preferences["#{type}_#{method}"].nil? || preferences["#{type}_#{method}"] == '1'
  end

  def accept_type_notification?(type)
    accept_notification?(type: type, method: :email) || accept_notification?(type: type, method: :sms) || accept_notification?(type: type, method: :in_app)
  end
end
