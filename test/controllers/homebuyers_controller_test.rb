# frozen_string_literal: true

require 'test_helper'

class HomebuyersControllerTest < ActionDispatch::IntegrationTest
  test 'always returns 5 useres even when looking for a new city' do
    get homebuyers_path, params: { city: 'san diego' }

    assert_response :success
    assert_equal 5, assigns[:homebuyers].count
  end
end
