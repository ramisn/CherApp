# frozen_string_literal: true

require 'test_helper'

module Users
  class ChatGroupsControllerTest < ActionDispatch::IntegrationTest
    test 'it redirects no logged user' do
      get chat_group_path('123abc')

      assert_redirected_to new_user_session_path
      assert_equal 'You need to sign in or sign up before continuing.', flash[:alert]
    end

    test 'it success showing a group' do
      login_as users(:co_borrower_user)
      WebStub.stub_twilio_chat_response
      WebStub.stub_twilio_chat_member_wiht_role

      get chat_group_path('123abc')

      assert_response :success
    end

    test 'it renders not found for invalid groups' do
      login_as users(:co_borrower_user)
      role_sid = '123abc'
      WebMock.stub_request(:get, %r{https://chat.twilio.com/v2/Services/.+/Channels/.+/Members/.+})
             .to_return(status: 200, body: { role_sid: '123abc' }.to_json)
      WebMock.stub_request(:get, "https://chat.twilio.com/v2/Services/#{ENV['TWILIO_SERVICE_SID']}/Roles/#{role_sid}")
             .to_return(status: 200, body: '')
      WebMock.stub_request(:get, "https://chat.twilio.com/v2/Services/#{ENV['TWILIO_SERVICE_SID']}/Channels/#{role_sid}")
             .to_return(status: 400, body: '', headers: {})

      get chat_group_path('123abc')

      assert_template :not_found
    end

    test 'it success creating a new group' do
      user_email = users(:agent_user).email
      login_as users(:co_borrower_user)
      WebMock.stub_request(:post, %r{https://chat.twilio.com/v2/Services.*})
             .to_return(status: 200, body: { sid: '123' }.to_json)

      post chat_groups_path, params: { group: { name: '123 Main street', participants: [user_email] }, format: :json }

      assert_response 201
    end

    test 'it enque a job when creating a group' do
      user_email = users(:agent_user).email
      login_as users(:co_borrower_user)
      WebMock.stub_request(:post, %r{https://chat.twilio.com/v2/Services.*})
             .to_return(status: 200, body: { sid: '123' }.to_json)

      assert_enqueued_with(job: GroupCreationNotifierJob) do
        post chat_groups_path, params: { group: { name: '123 Main street', participants: [user_email] }, format: :json }
      end

      assert_enqueued_jobs 1
    end
  end
end
