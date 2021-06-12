# frozen_string_literal: true

class DeleteVideoCallService
  def initialize(channel_sid)
    @channel_sid = channel_sid
  end

  def execute
    meeting = ChimeMeeting.find_open_meeting(@channel_sid)

    ChimeClient.delete_meeting(meeting.meeting_id)

    meeting.update(active: false)
  end
end
