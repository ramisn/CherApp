# frozen_string_literal: true

require 'test_helper'

class SendUserFeedbackMailsServiceTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  test 'sends emails to users with more than 30 minutes of signing up' do
    assert_emails 1 do
      5.times do
        SendUserFeedbackMailsService.new.execute
      end
    end
  end

  test 'send 5 emails through time' do
    assert_emails 5 do
      SendUserFeedbackMailsService.new.execute

      5.times do
        travel 1.day
        SendUserFeedbackMailsService.new.execute
      end
    end
  end
end
