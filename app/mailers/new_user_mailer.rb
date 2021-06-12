# frozen_string_literal: true

class NewUserMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def notify_cher(params)
    @user_email = params[:email]
    @user_role = params[:agent] ? 'customer' : 'user'
    @user_city = params[:city]
    receivers = ENV['NEW_USERS_RECEIVERS'].split(',')

    mail(to: receivers, subject: "A new #{@user_role} joined Cher")
  end

  def notify_agents(professional, params)
    @user_identifier = user_identifier(params[:first_name], params[:email])
    @user_email = params[:email]
    @user_role = params[:agent] ? 'customer' : 'user'
    @user_city = params[:city]
    @user_slug = params[:slug]
    @professional_identifier = user_identifier(professional.first_name, professional.email)

    mail(to: professional.email, subject: 'A new homebuyer just joined Cher!')
  end

  private

  def user_identifier(name, email)
    name.blank? ? email.split('@').first : name
  end
end
