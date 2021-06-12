# frozen_string_literal: true

require 'application_system_test_case'

class RegistrationTest < ApplicationSystemTestCase
  setup do
    WebStub.stub_sendgrid_validator
    WebStub.stub_sendgrid_contacts
    WebStub.stub_sendgrid_single_send
    WebStub.stub_mailchimp
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')

    WebMock.stub_request(:any, %r{chat.twilio.com/v2/Services.*})
           .to_return(status: 200)
  end

  test 'user can registered with valid params' do
    visit new_user_registration_path

    fill_in 'email', with: 'valid@example.com'
    fill_in 'password', with: 'Password1'
    fill_in 'confirm password', with: 'Password1'
    click_on 'Sign up'

    assert_content 'One click away', wait: 5
  end

  test 'user complete profile when registering' do
    WebStub.stub_properties_request
    visit new_user_registration_path

    fill_in 'email', with: 'valid@example.com'
    fill_in 'password', with: 'Password1'
    fill_in 'confirm password', with: 'Password1'
    click_on 'Sign up'
    choose 'Homebuyer | Seller | Owner | Renter', allow_label_click: true
    click_button 'Finish'

    assert_content 'User data successfully updated'
    assert_current_path co_borrower_root_path
  end

  test 'user cannot registered with invalid params' do
    visit new_user_registration_path

    fill_in 'email', with: 'invalid@example.com'
    fill_in 'password', with: 'password1'
    fill_in 'confirm password', with: 'password1'
    click_on 'Sign up'

    assert_content I18n.t('.password_complexity_error')
  end

  test 'user can soft-delete its account' do
    WebStub.stup_ghost_blog_post
    WebStub.stub_redis_properties
    @user = users(:co_borrower_user)
    sign_in @user
    visit edit_profile_path(@user.id)

    click_button 'Delete Account'
    click_link 'Confirm'

    assert page.has_content?('Bye! Your account has been successfully cancelled. We hope to see you again soon.')
  end
end
