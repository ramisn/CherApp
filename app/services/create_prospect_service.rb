# frozen_string_literal: true

class CreateProspectService
  def initialize(params, notify: true)
    @prospect = Prospect.new(params)
    @send_email = notify.nil? ? true : notify
  end

  def execute
    return response_with_errors(I18n.t('flashes.prospect.create.already_subscribed')) if user_already_subscribed?

    if @prospect.save
      notify_and_track_event
      OpenStruct.new(success?: true,
                     message_key: :notice,
                     message: I18n.t('flashes.prospect.create.notice'),
                     error: [],
                     prospect: @prospect)
    else
      response_with_errors(I18n.t('flashes.prospect.create.error'), @prospect.errors)
    end
  end

  private

  def notify_user?
    @prospect.email && @send_email
  end

  def notify_and_track_event
    MixpanelTracker.track_event(@prospect.email, 'Subscribed to newsletter', {})
    ActivityMailer.newsletter_subscribe(@prospect.email).deliver_later if notify_user?
  end

  def response_with_errors(message, errors = nil)
    OpenStruct.new(success?: false,
                   message_key: :alert,
                   message: message,
                   errors: errors || message,
                   prospect: @prospect)
  end

  def user_already_subscribed?
    Prospect.where(email: @prospect.email, phone_number: @prospect.phone_number).exists?
  end
end
