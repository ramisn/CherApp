# frozen_string_literal: true

require 'test_helper'

class LookAroundContrillerTest < ActionDispatch::IntegrationTest
  setup do
    WebStub.stub_redis_properties
  end

  test 'it success when accessing to look around show' do
    get look_around_path

    assert_response :success
  end

  test 'it success when requesting to create a search with params' do
    get look_around_path, params: { search: { search_type: :cities,
                                              search_in: 'Santa Monica',
                                              minbeds: 1, minbaths: 1,
                                              type: 'RNT' }, format: :json }

    assert_response :success
  end

  test 'it success when simplyrets request return error' do
    get look_around_path, params: { search: { search_type: :cities,
                                              search_in: 'Santa Monica',
                                              minbeds: 1, minbaths: 1,
                                              type: 'RNT' }, format: :json }

    assert_response :success
  end

  test "it updates user's search history" do
    co_borrower_user = users(:verified_user)
    login_as co_borrower_user

    get look_around_path, params: { search: { search_type: :cities,
                                              minbeds: 1, minbaths: 1,
                                              search_in: 'Santa Monica',
                                              type: 'RNT' }, format: :json }
    co_borrower_user.reload
    assert_equal ['santa monica'], co_borrower_user.search_history
  end

  test "it doesnt updates user's search history when accessing whithout a search" do
    co_borrower_user = users(:verified_user)
    login_as co_borrower_user

    get look_around_path, params: { search_in: 'Santa Monica', format: :html }
    co_borrower_user.reload
    assert_equal [], co_borrower_user.search_history
  end

  test "it doesn't duplicates cities in search history" do
    co_borrower_user = users(:verified_user)
    co_borrower_user.update(search_history: ['santa monica'])
    login_as co_borrower_user

    get look_around_path, params: { search: { search_type: :cities,
                                              search_in: 'Santa Monica',
                                              minbeds: 1, minbaths: 1,
                                              type: 'RNT' }, format: :json }

    co_borrower_user.reload
    assert_equal ['santa monica'], co_borrower_user.search_history
  end

  test 'it success when requesting for homes with filters' do
    get look_around_path, params: { search: { search_type: :cities,
                                              minbeds: 1,
                                              search_in: 'Santa Monica',
                                              maxprice: 100_000, minbaths: 2,
                                              water: true, minyear: 2020,
                                              maxrea: 500, features: 'fireplace',
                                              type: 'RNT' }, format: :json }

    assert_response :success
  end
end
