# frozen_string_literal: true

require 'application_system_test_case'

module CoBorrower
  class DashboardTest < ApplicationSystemTestCase
    setup do
      ChatTokensController.any_instance
                          .stubs(:generate_token)
                          .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
      login_as users(:co_borrower_user)
      ChatTokensController.any_instance.stubs(:generate_token).returns('')
      WebStub.stub_properties_request
    end

    test 'co borrower can access to new inquire section' do
      # Now it is invalid
      skip
      visit co_borrower_dashboard_path

      click_link 'Background Check'

      assert page.has_content?('Validate your profile by completing a background check!')
    end

    test 'co borrower can request a new inquiry with valid params' do
      # Now it is invalid
      skip
      visit co_borrower_dashboard_path
      click_link 'Background Check'

      fill_in 'inquiry[first_name]', with: 'Miguel'
      fill_in 'inquiry[last_name]', with: 'Urbina'
      page.execute_script('document.getElementById("inquiry_date_of_birth").value = "01/13/1997";')
      page.execute_script('document.getElementById("inquiry_accepttos").checked = true')
      page.execute_script('document.getElementById("inquiry_accepterms").checked = true')

      click_button 'Request Check'

      assert page.has_content?('Background check now is under review')
    end
  end
end
