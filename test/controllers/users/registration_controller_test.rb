# frozen_string_literal: true

require 'test_helper'

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test 'it succcess when registered user is valid' do
    WebStub.stub_sendgrid_validator
    WebMock.stub_request(:any, %r{api.sendgrid.com/.*})
           .to_return(status: 200)
    WebMock.stub_request(:any, %r{chat.twilio.com/v2/Services.*})
           .to_return(status: 200)
    post user_registration_path, params: { user: { email: 'miguel@michelada.io',
                                                   password: 'Password1',
                                                   password_confirmation: 'Password1' },
                                           format: :json }

    assert_response :success
  end

  test 'it fails when user is not valid' do
    WebStub.stub_sendgrid_validator
    post user_registration_path, params: { user: { email: 'miguel@michelada.io',
                                                   password: 'Password',
                                                   password_confirmation: 'Password1' },
                                           format: :json }

    assert_response 401
  end

  test 'it success creating new user' do
    WebStub.stub_sendgrid_validator
    WebMock.stub_request(:any, %r{api.sendgrid.com/.*})
           .to_return(status: 200)
    WebMock.stub_request(:any, %r{chat.twilio.com/v2/Services.*})
           .to_return(status: 200)

    assert_difference 'User.count', 1 do
      post user_registration_path, params: { user: { email: 'miguel+new@michelada.io',
                                                     password: 'Password1',
                                                     password_confirmation: 'Password1' },
                                             format: :html }
    end
  end

  test 'it render new registration when user is invalid' do
    WebStub.stub_sendgrid_validator
    WebMock.stub_request(:any, %r{api.sendgrid.com/.*})
           .to_return(status: 200)
    WebMock.stub_request(:any, %r{chat.twilio.com/v2/Services.*})
           .to_return(status: 200)
    post user_registration_path, params: { user: { email: 'miguel+new@michelada.io',
                                                   password: 'examplePss',
                                                   password_confirmation: 'Password1' },
                                           format: :html }
    assert_template :new
  end

  test 'it updates the search intent of the user' do
    WebStub.stub_sendgrid_validator
    WebStub.stub_sendgrid_contacts
    WebStub.stub_sendgrid_single_send
    WebMock.stub_request(:any, %r{chat.twilio.com/v2/.*})
           .to_return(status: 200)
    cookies[:search_intent] = 'inv'

    post user_registration_path, params: { user: { email: 'miguel@michelada.io',
                                                   password: 'Password1',
                                                   password_confirmation: 'Password1' },
                                           format: :html }

    assert_equal 'inv', User.last.search_intent
  end

  test 'it success discarting a user' do
    WebStub.stub_sendgrid_single_send
    user = users(:co_borrower_user)
    login_as user

    delete user_registration_path(user), params: { method: :delete }

    assert_redirected_to root_path
    assert user.discarded_at
  end
end
