# frozen_string_literal: true

require 'test_helper'

class TextMessagesControllerTest < ActionDispatch::IntegrationTest
  test 'it success requesting for a sms' do
    WebStub.stub_twilio_sms
    WebStub.stub_bitly

    post text_messages_path, params: { text_message: { message: 'Check out this video', link: 'http://cher.app', recipient: '1987843612' }, format: :json }

    assert_enqueued_jobs 1
    assert_response :success
  end

  test 'it fails requesting with an invalid phone number' do
    WebStub.stub_twilio_sms
    post text_messages_path, params: { text_message: { message: 'Check out this video', link: 'http://cher.app', recipient: '198784360' }, format: :json }

    assert_response 400
  end
end
