# frozen_string_literal: true

class ContactRequestMailer < ApplicationMailer
  def notify_cher(params)
    @name = params[:name]
    @email = params[:email]
    @phone = params[:phone]
    @city = params[:city]
    @state = params[:state]
    mail(to: [ENV['SUPPORT_MAIL'], ENV['SUPPORT_MAIL_2']] + ApplicationHelper::TEAM_MEBERS_EMAIL,
         subject: 'A prospect wants to be heard')
  end

  def notify_property_without_professional(params)
    @user_email = params[:user].email
    @property = params[:property]
    @cher_team = [ENV['ERIC_EMAIL'], ENV['PAUL_EMAIL']]

    mail(to: @cher_team, subject: 'No Realtor in the area')
  end

  def notify_contact_realtor(params)
    @sender = params[:user]
    @professional = params[:professional]
    @address = params[:address]
    @channel_sid = params[:channel_sid]

    mail(to: @professional.email, subject: "You've got a new lead!")
  end

  def notify_concierge(params)
    @user_name = params[:user].full_name
    @property = params[:address]
    @phone_number = params[:phone_number]

    mail(to: ENV['CONCIERGE_CHAT_EMAIL'], subject: 'New lead contacted an agent!')
  end

  def contact_concierge(params)
    @user = params[:user]
    @phone_number = params[:phone_number]
    @body = params[:body]

    mail(to: ENV['CONCIERGE_CHAT_EMAIL'], subject: 'A user contacted you')
  end
end
