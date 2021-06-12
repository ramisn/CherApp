# frozen_string_literal: true

require 'application_system_test_case'

module CoBorrower
  class PersonalityTest < ApplicationSystemTestCase
    setup do
      ChatTokensController.any_instance
                          .stubs(:generate_token)
                          .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
      WebStub.stub_properties_request
    end

    test 'verified user can reset personality test' do
      # Now it is invalid
      skip
      login_as users(:verified_user)
      visit co_borrower_dashboard_path

      click_link 'Personality Test'
      click_link "Let's do it"

      assert page.has_content?('Now you can complete the test again')
    end

    test 'no verified user is able to complete the test' do
      # Now it is invalid
      skip
      login_as users(:user_without_responses)
      visit co_borrower_dashboard_path

      click_link 'Personality Test'

      assert page.has_content?('Personality test')
    end

    test 'test blocked user can not complete personality test' do
      # Now it is invalid
      skip
      login_as users(:test_blocked_user)
      visit co_borrower_dashboard_path

      click_link 'Personality Test'

      assert page.has_content?("Personality test is blocked till #{Date.today + 1.day}")
    end

    test 'do not show personaly test link if user search intent is invest' do
      # Now it is invalid
      skip
      login_as users(:co_borrower_user_invest)
      visit co_borrower_dashboard_path

      refute page.has_content?('Personality test →')
    end
  end
end
