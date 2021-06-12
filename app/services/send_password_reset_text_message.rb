# frozen_string_literal: true

class SendPasswordResetTextMessage
  def initialize(user)
    @user = user
  end

  def execute
    user_name = @user.full_name.blank? ? I18n.t('generic.someone') : @user.full_name
    message = I18n.t('sms_notifications.reset_password', user_name: user_name)
    SendSmsService.new(message, @user.phone_number, sms_type: :password_reset).execute unless @user.phone_number.blank?
  end
end
