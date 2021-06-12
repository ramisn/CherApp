# frozen_string_literal: true

class FetchChannelParticipantsService
  def initialize(current_user, channel_sid)
    @channel_sid = channel_sid
    @current_user = current_user
  end

  def execute
    channel = MessageChannel.find_by(sid: @channel_sid)

    return delete_channel unless channel
    return [] if channel.purpose == 'concierge'

    User.not_current(@current_user.id).where(email: channel.participants)
  end

  private

  def delete_channel
    TwilioChatUtils.delete_channel(@channel_sid)
    []
  end
end
