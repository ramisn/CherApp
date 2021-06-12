# frozen_string_literal: true

class SellNotificationMailer < ApplicationMailer
  def notify_cher(user_name, house_id)
    @user_name = user_name
    @house_id = house_id
    mail(to: [ENV['SUPPORT_MAIL'], ENV['SUPPORT_MAIL_2']],
         subject: 'A user posted a house for sale')
  end
end
