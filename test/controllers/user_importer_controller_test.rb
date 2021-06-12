# frozen_string_literal: true

require 'test_helper'

class ImporterControllerTest < ActionDispatch::IntegrationTest
  test 'it redirects to new session when user is not logged' do
    get new_users_importer_path, params: { social_network: 'facebook', identifiers: ['123'] }

    assert_redirected_to new_user_session_path
  end

  test 'it success when loggen user request for new importation' do
    login_as users(:agent_user)

    get new_users_importer_path, params: { social_network: 'facebook', identifiers: ['123'] }

    assert_response :success
  end

  test 'it success when creating a new importation' do
    user_to_invite = users(:co_borrower_user)
    login_as users(:agent_user)

    post users_importer_index_path, params: { users: [user_to_invite.id], format: :json }

    assert_response :success
  end
end
