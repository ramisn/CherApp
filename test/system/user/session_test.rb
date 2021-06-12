# frozen_string_literal: true

require 'application_system_test_case'

class SessionTest < ApplicationSystemTestCase
  test 'discarded user cannot login' do
    discarded_user = users(:discarded_user)

    visit new_user_session_path
    fill_in 'email', with: discarded_user.email
    fill_in 'password', with: 'Password1'

    click_button 'Sign in'

    assert_content I18n.t('devise.failure.inactive')
    assert_current_path new_user_session_path
  end

  test 'no discarded user can login' do
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    WebStub.stub_properties_request
    WebStub.stub_redis_property
    co_borrower_user = users(:co_borrower_user)

    visit new_user_session_path
    fill_in 'email', with: co_borrower_user.email
    fill_in 'password', with: 'Password1'
    click_button 'Sign in'

    assert_content I18n.t('devise.sessions.signed_in')
    assert_current_path co_borrower_root_path
  end

  test 'user can close flash via button' do
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    WebStub.stub_properties_request
    WebStub.stub_redis_property
    user = users(:co_borrower_user)

    visit new_user_session_path
    fill_in 'email', with: user.email
    fill_in 'password', with: 'Password1'

    click_button 'Sign in'

    assert_content I18n.t('devise.sessions.signed_in')
    assert find('button.delete')

    find('button.delete').click

    refute_content 'Signed in successfully.'
  end

  test 'user is correctly redirected after sign in' do
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    user = users(:co_borrower_user)

    visit conversations_path

    fill_in 'email', with: user.email
    fill_in 'password', with: 'Password1'

    click_button 'Sign in'

    assert_content 'Messages'
    assert_content 'Filtered by:'
  end
end
