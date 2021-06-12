# frozen_string_literal: true

require 'application_system_test_case'

class LeadsTest < ApplicationSystemTestCase
  setup do
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
  end

  test 'customer can access to leads view' do
    professional = users(:clique_agent)
    sign_in professional

    visit customer_dashboard_path
    click_link 'Browse Leads'

    assert_content 'Suggested leads'
    assert_content 'Filter by city'
  end

  test 'customer can search leads by city' do
    professional = users(:clique_agent)
    sign_in professional

    visit customer_dashboard_path
    click_link 'Browse Leads'
    fill_in 'Search city...', with: 'Venice'
    find('button[type="submit"]').click

    assert_content "We're sorry, there are no new leads currently in your area."
  end

  test 'customer can see which users are logged in' do
    professional = users(:clique_agent)
    sign_in professional

    visit customer_dashboard_path
    assert find('.logged-in-ico')
  end

  test 'customer can invite from dashboard' do
    professional = users(:clique_agent)
    sign_in professional

    visit customer_dashboard_path
    click_link 'Browse Leads'
    sleep 1
    fill_in 'email[recipient_contact]', with: 'user@invited.com'
    fill_in 'user[recipient_first_name]', with: 'Borrower'
    fill_in 'user[recipient_last_name]', with: 'Invited'
    click_button 'Invite'

    assert_content 'Email sent'
  end
end
