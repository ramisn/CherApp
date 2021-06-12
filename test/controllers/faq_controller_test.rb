# frozen_string_literal: true

require 'test_helper'

class FaqControllerTest < ActionDispatch::IntegrationTest
  test 'it success accesing to show action' do
    get faq_path

    assert_response :success
  end
end
