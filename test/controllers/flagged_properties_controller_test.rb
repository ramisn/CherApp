# frozen_string_literal: true

require 'test_helper'

class FlaggedPropertiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @co_borrower_user = users(:co_borrower_user)
    @flagged_property = flagged_properties(:flagged_property)
  end

  test 'when a not authenticated user try to watch a property it gets redirected' do
    post flagged_properties_path, params: { property_id: 'QWR98', user_id: nil }
    assert_response :found
  end

  test 'a co-owner user can start watching a property' do
    WebStub.stub_properties_request
    WebStub.stub_sendgrid_single_send
    login_as @co_borrower_user
    params = { property_id: 'ASDF99', user_id: @co_borrower_user.id, city: 'Santa Monica', price: 3000, format: :json, status: 'active' }

    post flagged_properties_path, params: params

    assert_response :success
  end

  test 'a co-owner user can stop watching a property' do
    login_as @co_borrower_user

    delete flagged_property_path(@flagged_property.property_id), params: { format: :json }

    assert_response :success
  end
end
