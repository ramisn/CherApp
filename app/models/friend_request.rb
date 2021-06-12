# frozen_string_literal: true

# == Schema Information
#
# Table name: friend_requests
#
#  id           :integer          not null, primary key
#  requester_id :integer          not null
#  requestee_id :integer          not null
#  status       :integer          default("0"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class FriendRequest < ApplicationRecord
  include PublicActivity::Model
  tracked owner: proc { |_controller, model| User.find(model.requester_id) },
          recipient: proc { |_controller, model| User.find(model.requestee_id) },
          only: :create

  belongs_to :requester, class_name: 'User', foreign_key: 'requester_id'
  belongs_to :requestee, class_name: 'User', foreign_key: 'requestee_id'

  validates_presence_of :status
  validate :already_sent, if: -> { requester_id && requestee_id }
  enum status: %i[pending approved rejected]

  scope :user_pending_requests, ->(user_id) { where(requestee_id: user_id, status: :pending) }
  scope :request_accepted, ->(user_id) { where(requestee_id: user_id, status: :approved) }
  scope :request_requested, ->(user_id) { where(requester_id: user_id, status: :approved) }

  after_create :create_notification, :track_event

  def self.users_are_friends?(requester_id, requestee_id)
    FriendRequest.where(status: :approved)
                 .where("(requester_id = #{requester_id} AND requestee_id = #{requestee_id})
                         OR (requestee_id = #{requester_id} AND requester_id = #{requestee_id})")
                 .exists?
  end

  def self.request_status(current_user_id, requestee_id)
    FriendRequest.where("(requester_id = #{current_user_id} AND requestee_id = #{requestee_id})
                         OR (requestee_id = #{requestee_id} AND requester_id = #{current_user_id})")
                 .order(created_at: :asc)
                 .pluck(:status)
                 .first
  end

  def create_notification
    Notification.registry_friend_request(self)
  end

  def track_event
    SendFriendRequestTrackerJob.perform_later(self)
  end

  private

  def already_sent
    errors.add(:status, I18n.t('friend_request.status.already_friends')) if FriendRequest.users_are_friends?(requester_id, requestee_id)
  end
end
