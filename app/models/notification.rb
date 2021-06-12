# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id           :bigint           not null, primary key
#  owner_id     :bigint
#  recipient_id :bigint           not null
#  key          :string           not null
#  status       :integer          default("0"), not null
#  params       :json
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :owner, class_name: 'User', required: false

  validates_presence_of :key, :status
  validates :key, inclusion: { in: %w[friend_request flagged_property conversation_request account_confirmation
                                      complete_profile message_sent review_request share_property contact_realtor] }

  enum status: %i[pending readed]

  scope :active, -> { where(deleted_at: nil) }

  def self.registry_flagged_property(flagged_property)
    property = SimplyRets.find_property_by_id(flagged_property.property_id)
    return if property.nil?

    flagged_property.user.friends.each do |friend|
      next unless friend.accept_notification?(type: :flagged_home, method: :in_app)

      Notification.create!(owner: flagged_property.user,
                           recipient: friend,
                           key: 'flagged_property',
                           params: { property_id: flagged_property.property_id,
                                     city: property.dig('address', 'city') })
    end
  end

  def self.delete_flagged_property(flagged_property)
    flagged_property.user.friends.each do |friend|
      Notification.where("params ->> 'property_id' = '#{flagged_property.property_id}'", owner: flagged_property.user, recipient: friend, key: 'flagged_property')
                  .destroy_all
    end
  end

  def self.registry_friend_request(friend_request)
    return unless friend_request.requestee.accept_notification?(type: :friend_request, method: :in_app)

    Notification.create!(owner: friend_request.requester, recipient: friend_request.requestee, key: 'friend_request')
  end

  def self.registry_conversation_request(message_channel)
    owner = User.find_by(email: message_channel.participants.first)
    recipient = User.find_by(email: message_channel.participants.second)
    return unless recipient&.accept_notification?(type: :conversation, method: :in_app)

    Notification.create!(owner: owner, recipient: recipient, key: 'conversation_request')
  end

  def self.registry_new_chat_message(notification_params)
    owner = notification_params[:owner]
    recipient = notification_params[:recipient]
    link = notification_params[:link]

    return unless recipient&.accept_notification?(type: :conversation, method: :in_app)

    Notification.create!(owner: owner, recipient: recipient, key: 'message_sent', params: { link: link })
  end

  def self.registry_review(notification_params)
    owner = notification_params[:owner]
    recipient = notification_params[:recipient]
    link = notification_params[:link]

    return unless recipient&.accept_notification?(type: :ask_review, method: :in_app)

    Notification.create!(owner: owner, recipient: recipient, key: 'review_request', params: { link: link })
  end

  def self.registry_property(notification_params)
    owner = notification_params[:owner]
    recipient = notification_params[:recipient]
    link = notification_params[:link]

    return unless recipient&.accept_notification?(type: :property_share, method: :in_app)

    Notification.create!(owner: owner, recipient: recipient, key: 'share_property', params: { link: link })
  end

  def self.registry_contact_realtor(contact_realtor_params)
    owner = contact_realtor_params[:requester]
    recipient = contact_realtor_params[:professional]
    return unless recipient&.accept_notification?(type: :conversation, method: :in_app)

    Notification.create!(owner: owner, recipient: recipient, key: 'contact_realtor')
  end
end
