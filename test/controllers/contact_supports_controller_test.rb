# frozen_string_literal: true

require 'test_helper'

class ContactSupportsControllerTest < ActionDispatch::IntegrationTest
  test 'it success requesting for contact' do
    WebStub.stub_sendgrid_validator
    post contact_supports_path, params: { contact: { name: 'Paul',
                                                     email: 'user@cher.app',
                                                     phome: '11133334444' } }

    assert_redirected_to root_path
    assert_enqueued_emails 1
  end
end
