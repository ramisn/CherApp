# frozen_string_literal: true

class JoinVideoCallService
  def initialize(current_user, channel_sid)
    @current_user = current_user
    @channel_sid = channel_sid
  end

  def execute
    meeting = find_or_create_meeting
    attendee = ChimeClient.find_or_create_attendee(meeting, @current_user)

    return OpenStruct.new(meeting: nil, attendee: nil, status: 422, message: I18n.t('video_call.full')) if !attendee || !meeting

    OpenStruct.new(meeting: meeting, attendee: attendee, status: 201, message: I18n.t('video_call.joined'))
  rescue StandardError => _e
    OpenStruct.new(meeting: nil, attendee: nil, status: 500, message: I18n.t('video_call.error'))
  end

  private

  def find_or_create_meeting
    find_chime_meeting || create_meeting
  end

  def find_chime_meeting
    chime_meeting = ChimeMeeting.find_open_meeting(@channel_sid)
    return unless chime_meeting

    ChimeClient.get_meeting(chime_meeting.meeting_id)
  rescue StandardError => _e
    # In case AWS says that the call was not found, we have to set the call as inactive
    chime_meeting.update(active: false)
    nil
  end

  def create_meeting
    aws_meeting = ChimeClient.create_and_get_meeting(@channel_sid)

    ChimeMeeting.create(external_meeting_id: aws_meeting.external_meeting_id,
                        meeting_id: aws_meeting.meeting_id)

    aws_meeting
  end
end
