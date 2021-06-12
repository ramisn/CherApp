# frozen_string_literal: true

require 'application_system_test_case'

class  CallsTest < ApplicationSystemTestCase
  test 'user can request for a call' do
    WebStub.stup_ghost_blog_post
    WebStub.stub_redis_properties
    visit root_path

    find('#callWithUsButton').click
    fill_in 'call[phone_number]', with: '5512347611'
    click_button 'Call me'

    within('form[data-controller="calls"]') do
      assert_content 'Thank you! A member of our team will call you back shortly!'
    end
  end
end
