# frozen_string_literal: true

class UserSignUpFeedbackMailer < ApplicationMailer
  default from: ENV['SIGNUP_FEEDBACK_FROM_MAIL']

  def first_ask
    @user = params[:user]

    mail(to: @user.email, subject: "#{subject_start}, are you open for a quick call?")
  end

  def first_follow_up
    @user = params[:user]

    mail(to: @user.email, subject: "#{subject_start}, we are invited to be our advisor.")
  end

  def second_follow_up
    @user = params[:user]

    mail(to: @user.email, subject: "#{subject_start}, are we in touch?")
  end

  def gift_card
    @user = params[:user]

    mail(to: @user.email, subject: "#{subject_start}, wanted to thank you with a $5 gift card.")
  end

  def last_round
    @user = params[:user]

    mail(to: @user.email, subject: "#{subject_start}, reaching out one last time for your valuable advice.")
  end

  private

  def subject_start
    @user.full_name.blank? ? 'Hi' : @user.full_name
  end
end
