# frozen_string_literal: true

# == Schema Information
#
# Table name: flagged_properties
#
#  id          :bigint           not null, primary key
#  property_id :string           not null
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  city        :string           default(""), not null
#

require 'test_helper'
require 'public_activity/testing'
class FlaggedPropertyTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test 'flagged property is not valid without property id' do
    user = users(:co_borrower_user)
    flagged_property = FlaggedProperty.new(user: user)

    refute flagged_property.valid?
    assert flagged_property.errors[:property_id].any?
  end

  test 'flagged property is not valid without a user' do
    flagged_property = FlaggedProperty.new(property_id: '123as')

    refute flagged_property.valid?
    assert flagged_property.errors[:user].any?
  end

  test 'flagged property is valid with all attributes' do
    user = users(:co_borrower_user)

    flagged_property = FlaggedProperty.new(property_id: '123asd', user: user)

    assert flagged_property.valid?
  end

  test 'a notification job is enqueued after creating a flagged property' do
    user = users(:co_borrower_user)

    PublicActivity.without_tracking do
      assert_enqueued_with(job: CreateFlaggedPropertyNotificationJob) do
        FlaggedProperty.create(property_id: '123asd', user: user)
      end
    end
  end

  test 'notification is deleted after delete flagged property' do
    user = users(:co_borrower_user)
    PublicActivity.without_tracking do
      flagged_property = FlaggedProperty.create(property_id: '123asd', user: user)

      assert_difference 'Notification.count', -1 do
        flagged_property.destroy
      end
    end
  end
end
