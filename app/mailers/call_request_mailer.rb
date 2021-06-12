# frozen_string_literal: true

class CallRequestMailer < ApplicationMailer
  default from: 'cher@cher.app'

  def notify_admin(user_phone_number)
    @user_phone_number = user_phone_number
    mail(to: [ENV['SUPPORT_MAIL'], ENV['SUPPORT_MAIL_2']],
         subject: 'New call requested')
  end
end
