# frozen_string_literal: true

require 'test_helper'

class SendFlaggedPropertyTextMessageServiceTest < ActiveSupport::TestCase
  test 'it success sending  sms notification' do
    WebStub.stub_twilio_sms
    WebStub.stub_bitly
    user = users(:co_borrower_user)

    assert SendFlaggedPropertyTextMessageService.new(user, 'abc123', 'Santa Monica').execute
  end
end
