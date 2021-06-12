# frozen_string_literal: true

require 'test_helper'

class PropertiesContainerLocalsServiceTest < ActionDispatch::IntegrationTest
  setup do
    WebStub.stub_redis_null
    WebStub.stub_properties_request
  end

  test 'it success requesting for locals' do
    user = users(:co_borrower_user)

    response = LookAround::PropertiesContainerLocalsService.new(user, search_params).execute

    assert response.is_a?(Hash)
    assert_equal %i[saved_search flagged_properties_ids title can_save_search properties next_batch_link total_results], response.keys
    assert response[:can_save_search]
    assert_equal I18n.t('generic.search_result'), response[:title]
    assert_equal 1, response[:properties].size
  end

  test 'flagged properties is 0 when no user given' do
    response = LookAround::PropertiesContainerLocalsService.new(nil, search_params).execute

    assert_equal 0, response[:flagged_properties_ids].size
  end

  test 'flagged properties is 0 when user has not flagged a property' do
    user = users(:co_borrower_user_2)

    response = LookAround::PropertiesContainerLocalsService.new(user, search_params).execute

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
