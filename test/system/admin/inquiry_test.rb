# frozen_string_literal: true

require 'application_system_test_case'

module Admin
  class ProfessinoalTest < ApplicationSystemTestCase
    setup do
      ChatTokensController.any_instance
                          .stubs(:generate_token)
                          .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
      WebStub.stup_ghost_blog_post
      WebStub.stub_redis_properties
      @user_inquiry = users(:agent_user)
      login_as users(:admin_user)
      visit root_path
    end

    test 'admin can access to users inquiries request section' do
      find('.go-profile').hover
      click_link 'Inquiries'

      assert page.has_content?(@user_inquiry.full_name)
    end
  end
end
