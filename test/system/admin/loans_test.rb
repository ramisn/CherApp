# frozen_string_literal: true

require 'application_system_test_case'

module Admin
  class LoansTest < ApplicationSystemTestCase
    setup do
      ChatTokensController.any_instance
                          .stubs(:generate_token)
                          .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    end

    test 'admin can add missing user data' do
      login_as users(:admin_user)
      loan = loans(:co_borrower_loan)
      visit edit_admin_co_borrower_loan_path(loan.user, loan)

      page.execute_script("document.getElementById('user_date_of_birth').value = '12/01/1997';")
      fill_in 'SSN', with: '1234567890'
      click_button 'Update user data'

      assert_content 'User successfully updated'
    end

    test 'admin can add loan missing data' do
      login_as users(:admin_user)
      loan = loans(:co_borrower_loan)
      loan.user.update(date_of_birth: '13/01/1997', ssn: '1234567890', phone_number: '1234567890')
      visit edit_admin_co_borrower_loan_path(loan.user, loan)

      fill_in "Property's county", with: 'Los Angeles'
      fill_in "Property's zipcode", with: '90405'
      select 'Rejected', from: 'Status'
      click_button 'Update'

      assert_content 'Loan sucessfully updated'
    end
  end
end
