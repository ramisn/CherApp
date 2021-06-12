# frozen_String_literal: true

require 'application_system_test_case'

class ProfessionalLandingPageTest < ApplicationSystemTestCase
  setup do
    WebStub.stup_ghost_blog_post
    WebStub.stub_redis_properties
  end

  test 'user can access to regular landing page through navbar' do
    visit professionals_path

    page.execute_script 'window.scrollBy(0,10000)'
    click_link "I'm a Buyer"

    assert_content 'Everyone can be a homeowner'
  end

  test 'use rcan access to loging through navbar' do
    visit professionals_path

    click_link 'Log In'

    assert_content 'Sign In'
  end
end
