# frozen_string_literal: true

require 'test_helper'

class FindFlaggedPropertiesServiceTest < ActionDispatch::IntegrationTest
  setup do
    WebStub.stub_redis_null
    WebStub.stub_properties_request
  end

  test 'it success getting json response' do
    user = users(:co_borrower_user)

    response = LookAround::FindFlaggedPropertiesService.new(user).execute

    assert_equal Hash, response.class
    assert_equal %i[properties flagged_properties_ids can_save_search], response.keys
    assert_equal 3, response[:properties].size
    assert_equal 1, response[:flagged_properties_ids].size
    assert response[:properties].is_a?(Array)
    assert response[:flagged_properties_ids].is_a?(Array)
  end

  test 'flagge properties is 0 when user has no flagged found properties' do
    user = users(:co_borrower_user_2)

    response = LookAround::FindFlaggedPropertiesService.new(user).execute

    assert_equal 0, response[:flagged_properties_ids].size
  end

  test 'flagged properties id is 0 when no user given' do
    response = LookAround::FindFeaturePropertiesService.new(nil).execute

    assert_equal 0, response[:flagged_properties_ids].size
  end
end
