# frozen_string_literal: true

class UsersMailer < ApplicationMailer
  def confirmation(record, token)
    @user = record
    return if check_bounces(record.email)

    @dynamic_template_data = { confirmation_url: "#{ENV['APP_URL']}/users/confirmation?confirmation_token=#{token}",
                               user_name: record.first_name }
    mail to: record.email, subject: "#{record.first_name} Welcome to Cher Clique Agent!"
  end

  def password_reset(user, token)
    return if check_bounces(user.email)

    @token = token
    mail to: user.email, subject: 'Cher password reset'
  end

  def referral(user, token)
    @sender = { name: user.invited_by.full_name, email: user.invited_by.email }
    @dynamic_template_data = { link: "#{ENV['APP_URL']}/users/invitation/accept?invitation_token=#{token}",
                               friend_email: user.invited_by.email,
                               friend_name: user.invited_by.full_name }
    mail to: user.email, subject: '$500 for you and $500 for you friend'
  end

  def welcome_co_borrower(professional)
    @user = professional
    return if check_bounces(professional.email)

    mail to: professional.email, subject: 'Welcome To Cher'
  end

  def welcome_agent(user)
    @user = user
    return if check_bounces(user.email)

    mail to: user.email, subject: "#{user.first_name} Welcome to Cher Clique Agent!"
  end

  def notify_loan_owner(user)
    @user = user
    return if check_bounces(user.email)

    mail to: user.email, subject: 'Pre-approval application completed'
  end

  def notify_loan_invitation(participant)
    @participant = participant.user
    @loan = participant.loan
    @owner = participant.loan.user
    @token = participant.token
    mail to: participant.email, subject: 'Someone invited you to a loan process'
  end

  def notify_loan_completed(user)
    @user = user
    user_identifier = @user.full_name.blank? ? @user.email : @user.full_name
    mail to: @user.email, subject: "#{user_identifier}, you have completed your pre-approval application"
  end

  def notify_group_chat(user, inviter, channel_url)
    @inviter_identifier = inviter.full_name.blank? ? inviter.email : inviter.first_name
    @user_identifier = user.first_name.blank? ? user.email : user.first_name
    @channel_url = channel_url
    mail to: user.email, subject: "#{@inviter_identifier} is inviting you to a group chat"
  end

  def notify_property_changed(user)
    @user = user

    mail to: user.email, subject: 'Your DREAM home is calling!'
  end
end
