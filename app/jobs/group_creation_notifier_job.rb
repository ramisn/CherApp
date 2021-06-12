# frozen_string_literal: true

class GroupCreationNotifierJob < ApplicationJob
  queue_as :default

  def perform(chat_pariticipants, inviter, channel_url)
    chat_pariticipants.each do |participant_email|
      user = User.find_by(email: participant_email)
      sms_message = I18n.t('sms_notifications.group_created', recipient: user.first_name, inviter: inviter.first_name,
                                                              here_link: channel_url)

      UsersMailer.notify_group_chat(user, inviter, channel_url).deliver_later
      SendSmsService.new(sms_message, user.phone_number, sms_type: :chers_clique).execute if user.phone_number
    end
  end
end
