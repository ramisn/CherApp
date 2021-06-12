# frozen_string_literal: true

require 'test_helper'

class MatchesControllerTest < ActionDispatch::IntegrationTest
  test 'it redirects to login when no logged user access to index' do
    get matches_path

    assert_redirected_to new_user_session_path
  end

  test 'it success when logged user access to index' do
    login_as users(:co_borrower_user)

    get matches_path, params: { format: :json }

    assert_response :success
  end
end
