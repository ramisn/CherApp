# frozen_string_literal: true

require 'test_helper'

class EmailsControllerTest < ActionDispatch::IntegrationTest
  test 'it fails when requesting with an invalid email' do
    post email_path, params: { email: { recipient: 'miguel@cher' }, format: :json }

    assert_response 400
    assert 'Invalid email', response.message
  end

  test 'it success when requesting with a valid email' do
    WebStub.stub_sendgrid_single_send
    post email_path, params: { email: { recipient: 'miguel@cher.app', type: 'property', user_name: 'Fulanito' }, format: :json }

    assert_response :success
    assert 'Email sent', response.message
  end
end
