# frozen_string_literal: true

class ProfessionalContactService
  def initialize(requester, professionals, params)
    @requester = requester
    @professionals = professionals
    @params = params
  end

  def execute
    return contact_concierge if @params[:contact_concierge]

    notify_concierge
    return notify_cher_team if @professionals.blank?

    @professionals.each do |professional|
      setup_professional_channel(professional)
    end
    ProfessionalContactCheckerJob.set(wait: 30.minute)
                                 .perform_later(@requester, @params)
  end

  private

  def setup_professional_channel(professional)
    channel = create_message_channel
    message = I18n.t('generic.professional_contact', name: @params[:name], address: @params[:address])
    TwilioChatUtils.send_message(message, @requester.email, channel.sid)
    TwilioChatUtils.join_user_to_channel(@requester.email, channel.sid)
    TwilioChatUtils.invite_user_to_channel(professional.email, channel.sid)
    save_channel(channel, professional)
    notify_professional(professional, channel)
  end

  def create_message_channel
    channel_attributes = { purpose: 'professional_contact' }.to_json
    TwilioChatUtils.create_channel(@requester.email, channel_attributes)
  end

  def save_channel(channel, professional)
    MessageChannel.create(status: 'active',
                          sid: channel.sid,
                          purpose: 'professional_support',
                          participants: [@requester.email, professional.email])
  end

  def notify_professional(professional, channel)
    send_realtor_email(professional, channel)
    send_in_app_notification(professional)
    send_sms_notification(professional, channel)
  end

  def send_realtor_email(professional, channel)
    mail_params = { user: @requester, professional: professional, address: @params[:address],
                    channel_sid: channel.sid }

    ContactRequestMailer.notify_contact_realtor(mail_params).deliver_now
  end

  def send_in_app_notification(professional)
    contact_realtor_params = { requester: @requester, professional: professional }

    Notification.registry_contact_realtor(contact_realtor_params)
  end

  def send_sms_notification(professional, channel)
    return if professional.phone_number.blank?

    short_url = BitlyClient.short_url("#{ENV['APP_URL']}/conversations/#{channel.sid}")
    message = I18n.t('notifications.professional_lead', homebuyer: @requester.full_name, location: @params[:address], link: short_url)
    SendSmsService.new(message, professional.phone_number, sms_type: :professional_contact).execute
  end

  def notify_cher_team
    mail_params = { user: @requester, property: @params }
    ContactRequestMailer.notify_property_without_professional(mail_params).deliver_later
  end

  def notify_concierge
    mail_params = { user: @requester, address: @params[:address], phone_number: @params[:phone_number] }
    ContactRequestMailer.notify_concierge(mail_params).deliver_later
  end

  def contact_concierge
    mail_params = { user: @requester, phone_number: @params[:phone_number], body: @params[:body] }
    ContactRequestMailer.contact_concierge(mail_params).deliver_later
  end
end
