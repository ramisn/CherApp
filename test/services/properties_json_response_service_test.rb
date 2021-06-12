# frozen_string_literal: true

require 'test_helper'

class PropertiesJsonResponseServiceTest < ActionDispatch::IntegrationTest
  setup do
    WebStub.stub_redis_null
    WebStub.stub_properties_request
  end

  test 'it success geting response' do
    user = users(:co_borrower_user)

    response = LookAround::PropertiesJsonResponseService.new(user, search_params).execute

    assert response.is_a?(Hash)
    assert_equal %i[properties flagged_properties_ids notice], response.keys
    assert_equal 1, response[:properties].size
    assert_equal 1, response[:flagged_properties_ids].size
    assert_equal '', response[:notice]
  end

  test 'notice is error when no properties found' do
    WebStub.stub_empty_properties_response
    user = users(:co_borrower_user)

    response = LookAround::PropertiesJsonResponseService.new(user, search_params).execute

    assert_equal I18n.t('look_around.search.available_only_in'), response[:notice]
  end

  test 'flagged properties are 0 when no user given' do
    response =  LookAround::PropertiesJsonResponseService.new(nil, search_params).execute

    assert_equal 0, response[:flagged_properties_ids].size
  end

  test 'flagged properties are 0 when user has not flagged response properties' do
    user = users(:co_borrower_user_2)
    response = LookAround::PropertiesJsonResponseService.new(user, search_params).execute

    assert_equal 0, response[:flagged_properties_ids].size
  end

  def search_params
    { lastId: 0, amount: 100, search_in: 'Santa Monica', search_type: 'RNT',
      minprice: 0, home_type: 'condominium', maxprice: 100, minbeds: 1, minbaths: 1,
      minyear: 2_000, maxyear: 2_020, maxarea: 0, minarea: 0, minacres: 0, maxacres: 0,
      water: true, maxdom: nil, startdate: nil, start_hour: 13, start_minute: 0,
      features: '', exteriorFeatures:  '', type: [:rnt], status: [:active] }
  end
end
