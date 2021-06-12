# frozen_string_literal: true

require 'test_helper'

class NetworkWatchedPropertiesControllerTest < ActionDispatch::IntegrationTest
  test 'it redirects no logged user to new session' do
    get network_watched_properties_path

    assert_redirected_to new_user_session_path
  end

  test 'it success requesting for watched properties' do
    login_as users(:co_borrower_user)
    get network_watched_properties_path

    assert_response :success
  end
end
