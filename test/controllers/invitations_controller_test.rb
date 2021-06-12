# frozen_string_literal: true

require 'test_helper'

class InvitationsControllerTest < ActionDispatch::IntegrationTest
  test 'logged user can invite' do
    co_borrower = users(:co_borrower_user)
    sign_in co_borrower
    WebStub.stub_sendgrid_validator
    WebStub.stub_sendgrid_contacts
    WebStub.stub_sendgrid_single_send

    assert_difference 'User.count', 1 do
      post invite_path, params: { email: 'test@user.com' }
    end

    assert :succes
  end

  test 'no logged user cannot invite' do
    assert_no_difference 'User.count', 1 do
      post invite_path, params: { email: 'test@user.com' }
    end

    assert :redirect
  end

  test 'it creates an activity for new user and one for referral when inviting' do
    co_borrower = users(:co_borrower_user)
    sign_in co_borrower
    WebStub.stub_sendgrid_validator
    WebStub.stub_sendgrid_contacts
    WebStub.stub_sendgrid_single_send

    assert_difference 'PublicActivity::Activity.count', 2 do
      post invite_path, params: { email: 'test@user.com' }
    end
  end
end
