# frozen_string_literal: true

class TwilioSms
  ACCOUNT_SID = ENV['TWILIO_ACCOUNT_SID']
  TWILIO_AUTH_TOKEN = ENV['TWILIO_AUTH_TOKEN']
  TWILIO_SMS = ENV['TWILIO_PHONE_NUMBER']

  def self.send_notification(message, recipient)
    client.messages
          .create(
            body: message,
            from: TWILIO_SMS,
            to: recipient
          )
  end

  def self.client
    @client ||= Twilio::REST::Client.new(ACCOUNT_SID, TWILIO_AUTH_TOKEN)
  end
end
