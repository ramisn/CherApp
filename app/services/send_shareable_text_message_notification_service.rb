# frozen_string_literal: true

# frozen_stringcontroller

class SendShareableTextMessageNotificationService
  def initialize(message_params)
    @type = message_params[:type]
    @message = message_params[:message]
    @link = message_params[:link]
    @recipient = message_params[:recipient]
    @recipient_name = message_params[:recipient_name]
    @user_name = message_params[:user_name]
    @location = message_params[:address]
    @ending = message_params.key?(:ending) ? message_params[:ending] : true
  end

  def execute
    SendSmsService.new(build_message, @recipient, sms_type: @type).execute
  end

  private

  def build_message
    translation = I18n.t("share.share_#{@type}", user_name: @user_name, recipient_name: @recipient_name, location: @location, here_link: short_url)
    ending = I18n.t('share.share_ending', here_link: short_url) if @ending

    "#{translation}\n#{ending}\n#{@message}"
  end

  def short_url
    BitlyClient.short_url(@link)
  end
end
