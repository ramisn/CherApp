# frozen_string_literal: true

require 'application_system_test_case'

class OnboardingTest < ApplicationSystemTestCase
  setup do
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
  end

  test 'user is redirected to onbording when sign in' do
    WebStub.stub_properties_request
    visit new_user_session_path

    fill_in 'Email', with: 'borrower@user.com'
    fill_in 'Password', with: 'Password1'
    click_button 'Sign in'

    assert_content 'Where do you want to buy?'
  end

  test 'user who already selected a place to buy is redirected to dashboard on sign in' do
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    WebStub.stub_properties_request
    WebStub.stub_mailchimp
    borrower = users(:co_borrower_user)
    borrower.update(skip_onbording: true)
    visit new_user_session_path

    fill_in 'Email', with: borrower.email
    fill_in 'Password', with: 'Password1'
    click_button 'Sign in'

    assert_content 'Signed in successfully.'
  end
end
