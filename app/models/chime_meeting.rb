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
class ChimeMeeting < ApplicationRecord
  validates_presence_of :meeting_id, :external_meeting_id

  def self.find_open_meeting(channel_sid)
    ChimeMeeting.find_by(external_meeting_id: channel_sid, active: true)
  end
end
