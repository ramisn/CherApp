# frozen_string_literal: true

class ChimeClient
  REGION = ENV['AWS_CHIME_REGION']
  ENDPOINT = 'https://service.chime.aws.amazon.com/console'
  MAXIMUM_NUM_ATTENDEES = 5

  def self.client
    @client ||= begin
                  Aws.config.update(credentials: credentials)
                  Aws::Chime::Client.new(region: REGION, endpoint: ENDPOINT)
                end
  end

  # MEETING UTILS
  def self.get_meeting(meeting_id)
    client.get_meeting(meeting_id: meeting_id)&.meeting
  end

  def self.create_and_get_meeting(channel_sid)
    client.create_meeting(
      client_request_token: Digest::UUID.uuid_v4,
      external_meeting_id: channel_sid,
      media_region: REGION
    )&.meeting
  end

  def self.delete_meeting(meeting_id)
    client.delete_meeting(meeting_id: meeting_id)
  end

  def self.available_to_join?(meeting_id)
    list_attendees(meeting_id).count < MAXIMUM_NUM_ATTENDEES
  end

  # ATTENDEE UTILS

  def self.list_attendees(meeting_id)
    client.list_attendees(meeting_id: meeting_id).attendees
  end

  def self.find_or_create_attendee(meeting, user)
    return nil unless meeting

    get_attendee(meeting, user) || create_attendee(meeting, user)
  end

  def self.create_attendee(meeting, user)
    return nil unless available_to_join?(meeting.meeting_id)

    client.create_attendee(meeting_id: meeting.meeting_id,
                           external_user_id: user.external_attendee_name)&.attendee
  end

  def self.get_attendee(meeting, user)
    list_attendees(meeting.meeting_id).detect { |attendee| attendee[:external_user_id] == user.external_attendee_name }
  end

  def self.credentials
    Aws::Credentials.new(ENV['AWS_CHIME_ACCESS_KEY'], ENV['AWS_CHIME_SECRET_ACCESS_KEY'])
  end
end
