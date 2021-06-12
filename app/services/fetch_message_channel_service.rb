# frozen_string_literal: true

class FetchMessageChannelService
  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def execute
    @channel = MessageChannel.find_by_participants(@current_user.email, @user.email)
    return response(:found) if @channel

    create_channel
  end

  private

  def create_channel
    return not_permited_response if @current_user.agent? && !@current_user.can_start_conversation?

    @channel = MessageChannel.create_channel(@current_user.email, @user.email)
    notify_new_lead_contact if @current_user.agent?

    GroupCreationNotifierJob.perform_later([@user.email], @current_user, chat_group_url)
    response(:created)
  end

  def not_permited_response
    OpenStruct.new(success?: false, channel: nil, status: :not_enough_credits, message: I18n.t('dashboard.not_message_credits_left'))
  end

  def response(status)
    OpenStruct.new(success?: true, channel: @channel, status: status)
  end

  def chat_group_url
    Rails.application.routes.url_helpers.chat_group_url(@channel.sid, host: ENV['APP_URL'])
  end

  def notify_new_lead_contact
    @current_user.use_message_credit

    params = { agent_email: @current_user.email, user_email: @user.email, date: DateTime.current }
    ActivityMailer.new_agent_lead_credit(params).deliver_later
    ActivityMailer.notify_contacted_lead(@user.email).deliver_later
  end
end
