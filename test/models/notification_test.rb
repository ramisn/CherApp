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
require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  test 'it is not valid without recipient' do
    notification = Notification.new(key: 'friend_reqeust', status: :readed)

    refute notification.valid?
    assert notification.errors[:recipient].any?
  end

  test 'it is not valid without key' do
    notification = Notification.new(recipient: User.last, status: :readed)

    refute notification.valid?
    assert notification.errors[:key].any?
  end

  test 'it is not valid with an unknown key' do
    notification = Notification.new(recipient: User.last, key: 'invalid')

    refute notification.valid?
    assert notification.errors[:key].any?
  end

  test 'notification is valid with all attributes' do
    notification = Notification.new(recipient: User.last, key: 'flagged_property', params: { property_id: '123asd', city: 'Santa Monica' })

    assert notification.valid?
  end

  test 'it can registry new chat message' do
    notification_params = { owner: users(:co_borrower_user), recipient: User.last, link: 'cher.app' }
    notification = Notification.registry_new_chat_message(notification_params)

    assert notification.valid?
    assert_equal notification.key, 'message_sent'
  end

  test 'it can registry review' do
    notification_params = { owner: users(:co_borrower_user), recipient: User.last, link: 'cher.app' }
    notification = Notification.registry_review(notification_params)

    assert notification.valid?
    assert_equal notification.key, 'review_request'
  end

  test 'it can registry property' do
    notification_params = { owner: users(:co_borrower_user), recipient: User.last, link: 'cher.app' }
    notification = Notification.registry_property(notification_params)

    assert notification.valid?
    assert_equal notification.key, 'share_property'
  end
end
