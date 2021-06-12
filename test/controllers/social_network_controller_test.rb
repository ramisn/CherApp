# frozen_string_literal: true

require 'test_helper'

class SocialNetworkControllerTest < ActionDispatch::IntegrationTest
  test 'it redirect to login path when no logged user access to section' do
    get social_networks_path

    assert_redirected_to new_user_session_path
  end

  test 'it success when regular user access to section' do
    login_as users(:co_borrower_user)

    get social_networks_path

    assert_response :success
  end

  test 'it success when customer access to section' do
    login_as users(:agent_user)

    get social_networks_path

    assert_response :success
  end

  test 'user can also search for irregular text with no errors' do
    login_as users(:co_borrower_user)

    get social_networks_path, params: { user: { identifier: 'miguel @michelada.io' } }

    assert_equal 'No results for miguel @michelada.io', flash[:alert]
    assert_response :success
  end

  test 'logged user can do search' do
    login_as users(:co_borrower_user)
    create_pg_document

    get social_networks_path, params: { user: { identifier: 'new_borrower@user.com' } }

    assert_nil flash[:alert]
    assert :success
  end

  def create_pg_document
    WebStub.stub_sendgrid_validator
    WebStub.stub_sendgrid_contacts
    WebStub.stub_sendgrid_single_send
    User.create!(
      email: 'new_borrower@user.com',
      password: 'Password1',
      confirmed_at: Time.now,
      first_name: 'Borrower',
      last_name: 'User',
      role: 0
    )
  end
end
