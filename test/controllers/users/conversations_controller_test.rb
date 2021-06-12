# frozen_string_literal: true

require 'test_helper'

module Users
  class ConversationsControllerTest < ActionDispatch::IntegrationTest
    test 'it redirect no logged user' do
      get conversations_path

      assert_redirected_to new_user_session_path
      assert_equal 'You need to sign in or sign up before continuing.', flash[:alert]
    end

    test 'it success accessing to index' do
      login_as users(:co_borrower_user)

      get conversations_path

      assert_response :success
    end

    test 'it success showing not found view' do
      login_as users(:co_borrower_user)
      # 500 when channel not found
      WebMock.stub_request(:any, %r{chat.twilio.com/v2/Services.*})
             .to_return(status: 500, body: '')

      get conversation_path('CHq2123dd2d')

      assert_response :success
      assert_template :not_found
    end

    test 'it success showing a conversation' do
      login_as users(:co_borrower_user)
      WebMock.stub_request(:any, %r{chat.twilio.com/v2/Services.*})
             .to_return(status: 200, body: '')

      get conversation_path('CHq2123dd2d')

      assert_response :success
      assert_template :show
    end

    test 'it success accessing to a new conversation' do
      login_as users(:co_borrower_user)

      get new_conversation_path

      assert_response :success
      assert_template :new
    end
  end
end
