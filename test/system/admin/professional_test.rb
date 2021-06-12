# frozen_string_literal: true

require 'application_system_test_case'

module Admin
  class ProfessinoalTest < ApplicationSystemTestCase
    setup do
      ChatTokensController.any_instance
                          .stubs(:generate_token)
                          .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
      WebStub.stup_ghost_blog_post
      login_as users(:admin_user)
      visit root_path
      page.execute_script 'window.scrollBy(0,10000)'
      find('.go-profile').hover
      click_link 'Professionals'
    end

    test 'admin can see professionals' do
      assert page.has_content?('Professionals')
    end

    test 'admin can update professional verification' do
      click_link 'Verify', match: :first

      assert page.has_content?('Professional successfully updated')
    end

    test 'admin can see only no verfied professionals' do
      click_link 'No verified'

      assert page.has_content?('agent@user.com')
    end
  end
end
