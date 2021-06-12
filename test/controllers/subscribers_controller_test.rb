# frozen_string_literal: true

require 'test_helper'

class ProspectsControllerTest < ActionDispatch::IntegrationTest
  test 'any can register like new prospect' do
    WebStub.stub_sendgrid_validator
    WebStub.stub_sendgrid_contacts
    WebStub.stub_sendgrid_single_send
    assert_difference 'Prospect.count' do
      post prospect_path params: { prospect: { email: 'example+1@example.com' } }
    end
  end

  test 'can not repeat prospect' do
    WebStub.stub_sendgrid_contacts
    prospect = prospects(:miguel)

    assert_no_difference 'Prospect.count' do
      post prospect_path, params: { prospect: { email: prospect.email } }
    end
  end
end
