# frozen_string_literal: true

require 'test_helper'
require 'public_activity/testing'

class FlaggedNotificationTrackerJobTest < ActiveJob::TestCase
  test 'a job is enqueued after create flag a property' do
    WebStub.stub_redis_property
    user = users(:co_borrower_user)

    PublicActivity.without_tracking do
      assert_enqueued_with(job: FlaggedNotificationTrackerJob) do
        FlaggedProperty.create(property_id: '123asd', user: user)
      end
    end
  end
end
