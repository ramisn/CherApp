# frozen_string_literal: true

require 'application_system_test_case'

module CoBorrower
  class LoansTest < ApplicationSystemTestCase
    setup do
      ChatTokensController.any_instance
                          .stubs(:generate_token)
                          .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
      WebStub.stub_properties_request
    end

    test 'coborrower can skip process if house not choosed yet' do
      coborrower = users(:co_borrower_user_2)
      login_as coborrower

      visit co_borrower_dashboard_path
      find('.go-profile').hover
      within '.go-profile' do
        click_link 'Get Loan'
      end

      choose 'No, no yet', allow_label_click: true
      click_link 'Next'

      assert_content 'Featured Homes'
    end

    test 'coborrower can complete loan process' do
      ChatTokensController.any_instance
                          .stubs(:generate_token)
                          .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
      login_as users(:co_borrower_user_2)
      visit co_borrower_dashboard_path
      find('.go-profile').hover
      within '.go-profile' do
        click_link 'Get Loan'
      end

      click_button 'Next'
      fill_in 'Where is it?', with: 'Santa Monica'
      find('#propertyAddressInput').native.send_keys(:return)
      click_button 'Next', wait: 5
      click_button 'Next'
      click_button 'Next'
      choose "No, it's not", allow_label_click: true
      click_button 'Next'
      choose "No, I won't", allow_label_click: true
      click_button 'Finish'

      assert_content 'Loan successfully saved'
    end

    test 'user can see active loan process' do
      login_as users(:co_borrower_user)
      visit co_borrower_dashboard_path
      find('.go-profile').hover
      within '.go-profile' do
        click_link 'Get Loan'
      end

      assert_content 'Active loan request'
    end
  end
end
