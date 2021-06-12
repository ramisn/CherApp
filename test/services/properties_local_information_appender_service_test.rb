# frozen_string_literal: true

require('test_helper')

class PropertiesLocalInformationAppenderServiceTest < ActionDispatch::IntegrationTest
  test 'it success adding local information' do
    WebStub.stub_redis_null
    WebStub.stub_properties_request

    response = PropertiesLocalInformationAppenderService.new(properties).execute

    assert_equal 1, response.size
    assert response.first.key?('users_who_flagged')
    assert response.first.key?('selling_percentage')
    assert_equal [users(:co_borrower_user)], response.first['users_who_flagged']
  end

  test 'it appends no users when no one flagged property' do
    WebMock.stub_request(:any, /api.simplyrets.com.*/)
           .to_return(status: 200, body: [{ "listingId": '12329129312' }].to_json)

    response = PropertiesLocalInformationAppenderService.new(properties).execute

    assert_equal [], response.first['users_who_flagged']
  end

  def properties
    SimplyRets.request_properties([])
  end
end
