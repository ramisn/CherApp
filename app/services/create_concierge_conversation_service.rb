# frozen_string_literal: true

class CreateConciergeConversationService
  def initialize(user_concierge_id)
    @user_concierge_id = user_concierge_id || Digest::UUID.uuid_v4
  end

  def execute
    @channel = MessageChannel.find_by_participants(cher_concierge.email, @user_concierge_id)
    return response(:found) if @channel

    create_channel
  end

  private

  def create_channel
    @channel = MessageChannel.create_concierge_channel(cher_concierge.email, @user_concierge_id)

    response(:created)
  end

  def cher_concierge
    @cher_concierge ||= User.concierge_contact
  end

  def response(status)
    OpenStruct.new(success?: true, channel: @channel, status: status, user_concierge_id: @user_concierge_id)
  end
end
