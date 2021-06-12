# frozen_string_literal: true

require 'application_system_test_case'

class DashboardTest < ApplicationSystemTestCase
  setup do
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
  end

  test 'customer can select up to 10 areas' do
    professional = users(:agent_user)
    sign_in professional

    visit customer_dashboard_path
    find('#editProfessionalButton').click
    select 'Redwood city', from: 'areas'
    select 'Santa Monica', from: 'areas'
    select 'Alturas', from: 'areas'
    select 'Amador City', from: 'areas'
    select 'American Canyon', from: 'areas'
    select 'Anaheim', from: 'areas'
    select 'Anderson', from: 'areas'
    select 'Angels Camp', from: 'areas'
    select 'Antioch', from: 'areas'
    select 'Arcadia', from: 'areas'
    click_button 'saveProffessionalData'

    professional.reload
    assert ['Redwood city', 'Santa Monica', 'Alturas', 'Amador City', 'American Canyon', 'Anaheim', 'Anderson', 'Angels Camp', 'Antioch', 'Arcadia'], professional.areas
  end

  test 'customer can send message if has message_credits' do
    professional = users(:clique_agent)
    sign_in professional

    visit customer_dashboard_path

    assert_content 'Send message'

    assert_includes find('a', text: /Send message/)[:href], 'conversations'
  end

  test 'customer cannot send message if has no message_credits' do
    professional = users(:clique_agent)
    professional.update(message_credits: 0)

    sign_in professional

    visit customer_dashboard_path

    assert_content 'Send message'

    refute_includes find('a', text: /Send message/)[:href], 'conversations'
  end

  test 'customer can invite user from dashboard' do
    professional = users(:clique_agent)
    sign_in professional

    visit customer_dashboard_path

    assert_content 'Have any leads interested in sharing home ownership?'
    fill_in 'email[recipient_contact]', with: 'user@invited.com'
    fill_in 'user[recipient_first_name]', with: 'Borrower'
    fill_in 'user[recipient_last_name]', with: 'Invited'

    click_button 'Invite'
    assert_content 'Email sent'
  end
end
