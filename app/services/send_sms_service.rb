# frozen_string_literal: true

class SendSmsService
  def initialize(message, phone_number, sms_type: nil)
    @message = message
    @phone_number = phone_number
    @type = sms_type
  end

  def execute
    TwilioSms.send_notification(@message, @phone_number) if phone_number_can_receive_sms?
  end

  private

  def phone_number_can_receive_sms?
    return false if @phone_number.blank?

    user = User.find_by(phone_number: @phone_number)
    return true if user.nil?

    user.accept_notification?(type: @type, method: 'sms')
  end
end
