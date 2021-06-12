# frozen_string_literal: true

# == Schema Information
#
# Table name: message_channels
#
#  id           :bigint           not null, primary key
#  sid          :string
#  participants :string           default("{}"), is an Array
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  status       :integer          default("0")
#  purpose      :string           default("conversation")
#  image_url    :string
#

class MessageChannel < ApplicationRecord
  include PublicActivity::Model
  tracked owner: proc { |_controller, model| User.find_by(email: model.participants.first) },
          recipient: proc { |_controller, model| User.find_by(email: model.participants.second) },
          only: :create

  validates_presence_of :sid, :participants
  validates_inclusion_of :purpose, in: %w[group conversation professional_contact concierge]

  scope :conversation, -> { where.not(purpose: 'concierge') }
  scope :concierge, -> { where(purpose: 'concierge') }

  enum status: %i[active closed]

  after_create :registry_notification

  def registry_notification
    Notification.registry_conversation_request(self)
  end

  def self.find_by_participants(first_participant, second_participant)
    where('participants = ARRAY[?]::varchar[]', [first_participant, second_participant])
      .or(where('participants = ARRAY[?]::varchar[]', [second_participant, first_participant]))
      .first
  end

  def self.create_channel(first_participant, second_participant)
    channel = TwilioChatUtils.create_channel(first_participant, { purpose: 'conversation' }.to_json)
    TwilioChatUtils.join_user_to_channel(first_participant, channel.sid)
    TwilioChatUtils.join_user_to_channel(second_participant, channel.sid)
    MessageChannel.create!(participants: [first_participant, second_participant], sid: channel.sid, purpose: 'conversation')
  end

  def self.create_concierge_channel(concierge, user_concierge_id)
    channel = TwilioChatUtils.create_channel(concierge, { purpose: 'concierge' }.to_json)
    TwilioChatUtils.join_user_to_channel(concierge, channel.sid)
    TwilioChatUtils.join_user_to_channel(user_concierge_id, channel.sid)
    MessageChannel.create!(participants: [concierge, user_concierge_id], sid: channel.sid, purpose: 'concierge')
  end

  def self.remove_participant_from_channel(sid, email)
    channel = MessageChannel.find_by(sid: sid)
    channel.participants.delete(email)
    channel.save!
  end

  def self.add_participant_to_channel(sid, email)
    channel = MessageChannel.find_by(sid: sid)
    channel.participants << email
    channel.save!
  end
end
