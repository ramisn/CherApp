# frozen_string_literal: true

class RegistryTwilioUserJob < ApplicationJob
  queue_as :default

  def perform(user_email)
    TwilioChatUtils.create_user(user_email)
  rescue Twilio::REST::RestError => e
    Raven.capture_exception(e)
    false
  end
end
