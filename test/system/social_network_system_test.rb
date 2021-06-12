# frozen_string_literal: true

require 'application_system_test_case'

class SocialNetworkTest < ApplicationSystemTestCase
  setup do
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    WebStub.stub_properties_request
    login_as users(:verified_user)
    visit co_borrower_dashboard_path
    find('.go-profile').hover
    click_link 'My friends'
  end

  test 'user can visit message request section' do
    assert page.has_content?("Friends you'd like to buy with")
  end

  test 'use can send a friend request from suggested friends' do
    click_button 'Suggested Friends'
    within(first('.user-panel')) do
      click_on('+Add Co-Owner')

      assert_content 'Pending'
    end
  end

  test 'friend request appears in main view' do
    assert page.has_content?('Friend Requests')
  end

  test 'user is redirected to suggested match profile when clicking picture' do
    click_button 'Suggested Friends'
    first('.user-panel a').click

    assert page.has_content?('Flagged Properties')
  end

  test 'user can invite friend from popup' do
    click_button 'Invite Friends'

    fill_in 'email[recipient_contact]', with: 'friend@user.com'
    fill_in 'user[recipient_first_name]', with: 'Friend'
    fill_in 'user[recipient_last_name]', with: 'User'
    fill_in 'user[body]', with: 'Hey Check this out!'
    click_button 'Send'

    assert_content 'Email sent'
  end

  test 'user cannot invite friend with already registered email' do
    click_button 'Invite Friends'

    find('input[name="email[recipient_contact]"]').click
    fill_in 'email[recipient_contact]', with: 'no_responses@user.com'
    fill_in 'user[recipient_first_name]', with: 'Friend'
    fill_in 'user[recipient_last_name]', with: 'User'
    fill_in 'user[body]', with: 'Hey Check this out!'
    click_button 'Send'

    assert_content 'The email has already been taken'
  end
end
