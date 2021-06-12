# frozen_string_literal: true

require 'test_helper'

class Admin::ContactsControllerTest < ActionDispatch::IntegrationTest
  test 'it redirects no logged user to new session path' do
    get admin_contacts_path

    assert_redirected_to new_user_session_path
  end

  test 'it redirects no admin users to landing page' do
    login_as users(:co_borrower_user)

    get admin_contacts_path

    assert_redirected_to root_path
  end

  test 'it success when admin access to prospects section' do
    WebStub.stub_sendgrid_contacts
    login_as users(:admin_user)

    get admin_contacts_path

    assert_response :success
  end

  test 'it success requesting for a prospect creation' do
    WebStub.stub_sendgrid_contacts
    prospects_csv = fixture_file_upload('files/prospects.csv', 'text/csv')
    login_as users(:admin_user)

    post admin_contacts_path(format: :csv), params: { contact: { file: prospects_csv } }

    assert_redirected_to admin_contacts_path
  end

  test 'it success deleting a contact' do
    login_as users(:admin_user)

    delete admin_contact_path(contacts(:co_borrower_contact))

    assert_redirected_to admin_contacts_path
    assert_equal 'User deleted successfully', flash[:notice]
  end
end
