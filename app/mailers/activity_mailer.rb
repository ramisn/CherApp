# frozen_string_literal: true

class ActivityMailer < ApplicationMailer
  SENDER_EMAIL = 'cher@cher.marketing'
  DRIP_CAMPAIGN_CONFIG = { user_name: ENV['DRIP_CAMPAIGN_USERNAME'],
                           password: ENV['DRIP_CAMPAIGN_PASSWORD'],
                           address: ENV['DRIP_CAMPAIGN_ADDRESS'] }.freeze

  add_template_helper(PropertiesHelper)

  def share_property(email_params, user)
    recipient = email_params[:recipient]
    contact = User.find_by(email: recipient)

    return if check_bounces(recipient) || accepts_property_notification?(contact, email_params[:property_id])

    @dynamic_template_data = { property_address: email_params[:address],
                               property_url: email_params[:link],
                               message_body: email_params[:body],
                               user_name: user_name(email_params, user) }
    mail to: recipient, subject: "Your friend #{user_name(email_params, user)} finds you a perfect house at Cher."
  end

  def newsletter_subscribe(email)
    contact = User.find_by(email: email)
    @user = contact

    return if check_bounces(email) || (contact && !contact.accept_notification?(type: :subscription, method: :email))

    mail to: email, subject: 'Thanks for subscribing Cher!'
  end

  def share_post(email_params, user)
    recipient = email_params[:recipient]
    contact = User.find_by(email: recipient)

    return if check_bounces(recipient) || (contact && !contact.accept_notification?(type: :post_share, method: :email))

    @user = user
    @dynamic_template_data = { user_name: user_name(email_params, user),
                               post_url: email_params[:link],
                               message_body: email_params[:body] }
    mail to: recipient, subject: "Your friend #{user_name(email_params, user)} is very active at Cher and wants you to check it out"
  end

  def share_review(email_params, user)
    recipient = email_params[:recipient]
    contact = User.find_by(email: recipient)

    return if check_bounces(recipient) || (contact && !contact.accept_notification?(type: :review_share, method: :email))

    @dynamic_template_data = { message_body: email_params[:body],
                               user_name: user_name(email_params, user),
                               recipent_name: recipent_name(contact, recipient),
                               user_profile_path: user_url(user, host: ENV['APP_URL']) }
    mail to: recipient, subject: "Create your free account to leave #{user_name(email_params, user)} a review"
  end

  def share_video(email_params, user)
    recipient = email_params[:recipient]
    contact = User.find_by(email: recipient)

    return if check_bounces(recipient) || (contact && !contact.accept_notification?(type: :video_share, method: :email))

    @dynamic_template_data = { recipient_name: email_params[:recipient_name],
                               user_name: user_name(email_params, user),
                               video_url: email_params[:link],
                               message_body: email_params[:body] }
    mail to: recipient, subject: "#{user_name(email_params, user) || 'A friend'} wants to share you a video from Cher"
  end

  def weekly_properties_drip(properties, user)
    @properties = properties
    @user = user

    @headline_property, @headline_property_type = @properties.each do |type, homes|
      first = homes.shift
      break [first, type] if first
    end

    mail from: SENDER_EMAIL,
         to: user.email,
         subject: 'Cher found these homes that you might like',
         delivery_method_options: DRIP_CAMPAIGN_CONFIG
  end

  def weekly_leads_drip(drip_params, agent)
    @drip_params = drip_params
    @professional = agent

    mail from: SENDER_EMAIL,
         to: agent.email,
         subject: weekly_leads_subject(drip_params),
         layout: 'trans_mailer',
         delivery_method_options: DRIP_CAMPAIGN_CONFIG
  end

  def share_new_chat_message(email_params, user)
    recipient = email_params[:recipient]

    @dynamic_template_data = { recipient_name: email_params[:recipient_name],
                               user_name: user_name(email_params, user),
                               chat_url: email_params[:link] }

    mail to: recipient, subject: 'New chat message on Cher'
  end

  def new_agent_lead_credit(params)
    @params = params

    mail to: ENV['CONCIERGE_CHAT_EMAIL'], subject: 'A lead used a credit!'
  end

  def notify_contacted_lead(user_email)
    mail to: user_email, subject: 'Knock, Knock!🏡✨'
  end

  private

  def user_name(email_params, user)
    email_params[:user_name] || (user&.full_name.blank? ? user.email : user.full_name)
  end

  def recipent_name(contact, recipient)
    !contact&.full_name.blank? ? contact.full_name : recipient
  end

  def weekly_leads_subject(drip_params)
    area = drip_params.users_by_area.keys.first

    return 'Buyers are looking for homes' unless area

    num_of_users = drip_params.users_by_area[area][:users].count

    "#{num_of_users} buyers are looking for homes in #{area}"
  end
end
