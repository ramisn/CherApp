# frozen_string_literal: true

require 'test_helper'

class FriendRequestsControllerTest < ActionDispatch::IntegrationTest
  test 'it redirect no logged user' do
    requestee = users(:co_borrower_user)
    post friend_requests_path, params: { friend_request: { requestee_id: requestee.id } }

    assert_redirected_to new_user_session_path
  end

  test 'it success when requesting friends' do
    login_as users(:co_borrower_user_2)

    get friend_requests_path(format: :json)

    assert_response :success
  end

  test 'it redirect to root path by default when creating new request' do
    WebStub.stub_sendgrid_single_send
    login_as users(:verified_user)
    requestee = users(:co_borrower_user)

    assert_difference 'FriendRequest.count', 1 do
      post friend_requests_path, params: { friend_request: { requestee_id: requestee.id } }
    end
    assert_redirected_to root_path
    assert_equal 'Friend request sent', flash[:notice]
    assert_enqueued_jobs 2
  end

  test 'it redirect to dashboard when requests comes from no previous path when updating friend request' do
    WebStub.stub_sendgrid_single_send
    co_borrower_user = users(:co_borrower_user_2)
    request = friend_requests(:co_borrower_user_2_request)
    login_as co_borrower_user

    patch friend_request_path(request), params: { friend_request: { status: :approved }, format: :json }

    refute_equal request.reload.requestee_id, request.reload.requester_id
    assert_equal request.reload.requestee_id, co_borrower_user.id
  end

  test 'it success accepting a friend request' do
    friend_request = friend_requests(:co_borrower_user_2_request)
    login_as users(:co_borrower_user_2)

    patch friend_request_path(friend_request), params: { friend_request: { status: :approved } }

    assert_equal :approved, friend_request.reload.status.to_sym
  end

  test 'it enqueues a tracker job when accepting request' do
    friend_request = friend_requests(:co_borrower_user_2_request)
    login_as users(:co_borrower_user_2)

    assert_enqueued_with(job: MadeFriendTrackerJob) do
      patch friend_request_path(friend_request), params: { friend_request: { status: :approved } }
    end
  end

  test 'it success creating a friend request' do
    WebStub.stub_sendgrid_single_send
    future_friend = users(:user_without_responses)
    login_as users(:verified_user)

    assert_difference 'FriendRequest.count', 1 do
      post friend_requests_path, params: { friend_request: { requestee_id: future_friend.id } }
    end
    assert_redirected_to root_path
    assert_equal 'Friend request sent', flash[:notice]
    assert_enqueued_jobs 2
  end

  test 'it redirects to complete profile when user has no name' do
    co_borrower = users(:co_borrower_user)
    co_borrower.update!(first_name: nil, last_name: nil)
    future_friend = users(:user_without_responses)
    login_as co_borrower

    post friend_requests_path, params: { friend_request: { requestee_id: future_friend.id } }

    assert_redirected_to edit_profile_path(co_borrower)
    assert_equal 'You need to complete you profile first', flash[:alert]
  end
end
