# frozen_string_literal: true

require 'application_system_test_case'

class ActivationsTest < ApplicationSystemTestCase
  test 'discarted user can request for activate account' do
    WebStub.stup_ghost_blog_post
    WebStub.stub_properties_request
    WebStub.stub_redis_properties
    discarded_user = users(:discarded_user)
    visit new_user_registration_path

    click_link 'Activate account'
    fill_in 'activation_email', with: discarded_user.email
    click_button 'Send me instructions'

    assert_content 'You will receive an email with instructions for how to confirm your account'
  end

  test 'no discarded use can not request for account activation' do
    user = users(:co_borrower_user)
    visit new_user_registration_path

    click_link 'Activate account'
    fill_in 'activation_email', with: user.email
    click_button 'Send me instructions'

    assert_content 'Your account is already active'
  end

  test 'user can not request for activate account with no registered email' do
    visit new_user_registration_path

    click_link 'Activate account'
    fill_in 'activation_email', with: 'email_no_regisered@cher.app'
    click_button 'Send me instructions'

    assert_content 'User not found. Plase verify the given email'
  end
end
