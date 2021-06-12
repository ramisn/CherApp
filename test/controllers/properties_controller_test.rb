# frozen_string_literal: true

require 'test_helper'

class PropertiesControllerTest < ActionDispatch::IntegrationTest
  # Beign an agent renders an extra block
  test 'it success listing properties' do
    login_as users(:agent_user)
    WebStub.stub_property_places
    WebStub.stub_properties_request
    WebStub.stub_walkscore
    WebStub.stub_attom
    WebStub.stub_frankenstein
    request_link = 'https://api.simplyrets.com/properties?offset=30&limit=10&search_in=Santa Monica&search_type=cities&type=residential&cities=Santa Monica&vendor=claw'

    get properties_path, params: { link: request_link, format: :json }

    assert_response :success
  end

  test 'it success when requesting for a property in html' do
    WebStub.stub_property_places
    WebStub.stub_properties_request
    WebStub.stub_walkscore
    WebStub.stub_attom
    WebStub.stub_frankenstein
    get property_path('144412235')

    assert_response :success
  end

  test 'it success requesting for property in json' do
    WebStub.stub_property_places
    WebStub.stub_properties_request
    WebStub.stub_walkscore
    WebStub.stub_attom
    WebStub.stub_frankenstein
    get property_path('144412235'), params: { format: :json }

    assert_response :success
  end

  # Beign an agent renders an extra block
  test 'it success requesting for property in json beign an agent' do
    WebStub.stub_property_places
    WebStub.stub_properties_request
    WebStub.stub_walkscore
    WebStub.stub_attom
    WebStub.stub_frankenstein
    login_as users(:agent_user)

    get property_path('144412235'), params: { format: :json }

    assert_response :success
  end

  test 'it renders not found with unavailable properties' do
    WebStub.stub_redis_null
    WebStub.stub_empty_properties_response

    get property_path('144412235')

    assert_template :not_found
  end

  test 'it creates a seen property record when user logged in' do
    WebStub.stub_property_places
    WebStub.stub_properties_request
    WebStub.stub_walkscore
    WebStub.stub_attom
    WebStub.stub_frankenstein

    sign_in users(:agent_user)

    assert_difference 'SeenProperty.count', 1 do
      get property_path('144412235')
    end
  end

  test 'it does not create a seen property record when user not logged in' do
    WebStub.stub_property_places
    WebStub.stub_properties_request
    WebStub.stub_walkscore
    WebStub.stub_attom
    WebStub.stub_frankenstein

    assert_no_difference 'SeenProperty.count' do
      get property_path('144412235')
    end
  end
end
