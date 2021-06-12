# frozen_string_literal: true

require 'test_helper'

class CallsControllerTest < ActionDispatch::IntegrationTest
  test 'it success when requesting a call' do
    post calls_path, params: { call: { phone_number: '5512347611' } }

    assert_response :success
    assert 'Thank you! A member of our team will call you back asap!', response
    assert_enqueued_emails 1
  end

  test 'it returnd error message when requesting call with incalid number' do
    post calls_path, params: { call: { phone_number: '551234761e' } }

    assert_response :success
    assert 'Invalid given phone number', response
    assert_enqueued_emails 0
  end
end
