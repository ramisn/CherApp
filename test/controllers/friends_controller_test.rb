# frozen_string_literal: true

require 'test_helper'

class FriendsControllerTest < ActionDispatch::IntegrationTest
  test 'it redirect to login when no user loged' do
    get friends_path

    assert_redirected_to new_user_session_path
  end

  test 'it success when accessing to index' do
    login_as users(:co_borrower_user)

    get friends_path, params: { format: :json }

    assert_response :success
  end
end
