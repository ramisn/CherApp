# frozen_string_literal: true

require 'application_system_test_case'

class DashboardTest < ApplicationSystemTestCase
  setup do
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    WebStub.stub_properties_request
    @user = users(:user_without_role)
    sign_in @user
    visit edit_profile_path(@user)
    WebStub.stub_mailchimp
    WebStub.stub_sendgrid_contacts
    WebStub.stub_sendgrid_single_send
    WebStub.stub_sendgrid_contacts_search
  end

  test 'user can complete profile as homebuyer' do
    choose('user_role_co_borrower', allow_label_click: true)
    click_button 'Finish'

    assert_content 'User data successfully updated'
  end

  test 'user can complete profile as real state agent' do
    choose('user_role_agent', allow_label_click: true)
    select 'Estate Agent', from: 'Please be more specific'
    page.execute_script('document.getElementById("user_accept_referral_agreement").checked = true')
    click_button 'Finish'

    assert_content 'User data successfully updated'
  end

  test 'do not save search intent for agent user' do
    choose('user_role_agent', allow_label_click: true)

    click_button 'Finish'

    @user.reload

    assert_nil @user.search_intent
  end

  test 'user can save a phone number' do
    sign_out :user

    @user = users(:co_borrower_user)
    sign_in @user

    visit edit_profile_path(@user)

    fill_in 'user[phone_number]', with: '+523121234567'

    click_button 'Save'

    assert_content 'User data successfully updated'
  end

  test 'user can change email' do
    sign_out :user

    new_email = 'new_email@cher.app'
    @user = users(:co_borrower_user)
    sign_in @user

    visit edit_profile_path(@user)

    fill_in 'user[email]', with: ''
    fill_in 'user[email]', with: new_email

    click_button 'Save'

    assert_content 'User data successfully updated'
  end

  test 'user can change personal info' do
    sign_out :user
    sign_in users(:co_borrower_user)
    visit edit_profile_path(@user)

    click_link 'Personal info'

    select 'Male', from: 'user[gender]'
    select '$200K', from: 'user[budget_from]'

    click_button 'Save'

    assert_content 'User data successfully updated'
  end

  test 'agent cannot set any personal info' do
    sign_out :user
    sign_in users(:agent_user)

    visit edit_profile_path(@user)

    refute_content 'User data successfully updated'
  end

  test 'user needs to confirm account deletion' do
    sign_out :user
    sign_in users(:co_borrower_user)
    visit edit_profile_path(@user)

    click_button 'Delete Account'

    assert_content 'Are you sure you would like to delete your account?'
    assert_content 'Confirm'
  end
end
