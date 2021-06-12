# frozen_string_literal: true

# == Schema Information
#
# Table name: chime_meetings
#
#  id                  :bigint           not null, primary key
#  meeting_id          :string           not null
#  external_meeting_id :string           not null
#  active              :boolean          default("true"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require 'test_helper'

class ChimeMeetingTest < ActiveSupport::TestCase
  test 'is valid' do
    meeting = ChimeMeeting.new(chime_meeting_params)
    assert meeting.valid?
  end

  test 'is invalid' do
    meeting = ChimeMeeting.new(chime_meeting_params(meeting_id: nil))
    refute meeting.valid?
  end

  test 'can find open meeting by channel_sid' do
    meeting = ChimeMeeting.find_open_meeting('Chime2')
    assert meeting
  end

  private

  def chime_meeting_params(params = {})
    { meeting_id: 'awee-123',
      external_meeting_id: 'Cher1' }.merge(params)
  end
end
