# frozen_string_literal: true

require 'test_helper'

class LandingPageControllerTest < ActionDispatch::IntegrationTest
  test 'it can access to landing page' do
    WebStub.stup_ghost_blog_post
    WebStub.stub_redis_properties
    get root_path

    assert_response :success
  end
end
