# frozen_string_literal: true

require 'application_system_test_case'

class PasswordTest < ApplicationSystemTestCase
  setup do
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
  end

  test 'user can request for password reset' do
    WebStub.stup_ghost_blog_post
    WebStub.stub_sendgrid_single_send
    user = users('co_borrower_user')
    visit new_user_password_path

    fill_in 'Email', with: user.email
    click_button 'Send me instructions'

    assert_content 'You will receive an email with instructions on how to reset your password in a few minutes.'
  end

  test 'user can update password' do
    WebStub.stup_ghost_blog_post
    WebStub.stub_redis_properties
    user = users('co_borrower_user')
    raw_password, encrypted_password = Devise.token_generator.generate(user.class, :reset_password_token)
    user.update!(reset_password_token: encrypted_password, reset_password_sent_at: Time.now)

    visit edit_user_password_path(reset_password_token: raw_password)
    fill_in 'New password', with: 'Password1'
    fill_in 'Confirm your new password', with: 'Password1'
    click_button 'Change my password'

    assert_content 'Your password has been changed successfully. You are now signed in.', wait: 5
  end
end
