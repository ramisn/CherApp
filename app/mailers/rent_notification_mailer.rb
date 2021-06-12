# frozen_string_literal: true

class RentNotificationMailer < ApplicationMailer
  def notify_cher(user, house_id)
    @user = user
    @house_id = house_id
    mail(to: [ENV['SUPPORT_MAIL'], ENV['SUPPORT_MAIL_2']],
         subject: 'A user posted a house for rent')
  end
end
