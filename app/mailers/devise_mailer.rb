# frozen_string_literal: true

class DeviseMailer < Devise::Mailer
  APP_URL = ENV['APP_URL']

  def confirmation_instructions(record, token, _opts = {})
    UsersMailer.confirmation(record, token).deliver_later
  end

  def invitation_instructions(record, token, _opts = {})
    UsersMailer.referral(record, token).deliver_later
  end

  def reset_password_instructions(record, token, _opts = {})
    UsersMailer.password_reset(record, token).deliver_later
    SendPasswordResetTextMessage.new(record).execute
  end
end
