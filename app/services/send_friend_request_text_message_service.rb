# frozen_string_literal: true

class SendFriendRequestTextMessageService
  def initialize(friend_request)
    @requester = friend_request.requester
    @requestee = friend_request.requestee
  end

  def execute
    user_name = @requester.full_name.blank? ? t('generic.a_friend') : @requester.full_name
    message = I18n.t('sms_notifications.friend_request', user_name: user_name)
    SendSmsService.new(message, @requestee.phone_number, sms_type: :friend_request).execute unless @requestee.phone_number.blank?
  end
end
