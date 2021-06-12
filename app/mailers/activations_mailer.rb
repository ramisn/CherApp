# frozen_string_literal: true

class ActivationsMailer < ApplicationMailer
  def notify_user(user)
    @user = user
    mail(to: user.email,
         subject: 'Activate Cher account')
  end
end
