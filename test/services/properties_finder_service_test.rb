# frozen_string_literal: true

require 'test_helper'

class PropertiesFinderServiceTest < ActionDispatch::IntegrationTest
  setup do
    WebStub.stub_redis_null
    WebStub.stub_properties_request
  end

  test 'it success finding properties from redis' do
    user = users(:co_borrower_user)
    WebStub.stub_redis_properties

    response = PropertiesFinderService.new(search_params, user).execute

    assert_equal %i[properties next_batch_link total_results], response.keys
    assert_equal 1, response[:properties].size
  end

  test 'it success finding properties from simplyrets' do
    user = users(:co_borrower_user)

    response = PropertiesFinderService.new(search_params, user).execute

    assert_equal %i[properties next_batch_link total_results], response.keys
    assert_equal 1, response[:properties].size
  end

  def search_params
    { lastId: 0, amount: 100, search_in: 'Santa Monica', search_type: 'RNT',
      minprice: 0, home_type: 'condominium', maxprice: 100, minbeds: 1, minbaths: 1,
      minyear: 2_000, maxyear: 2_020, maxarea: 0, minarea: 0, minacres: 0, maxacres: 0,
      water: true, maxdom: nil, startdate: nil, start_hour: 13, start_minute: 0,
      features: '', exteriorFeatures:  '', type: [:rnt], status: [:active] }
  end
end
