# frozen_string_literal: true

require 'application_system_test_case'

class LandingPageTest < ApplicationSystemTestCase
  setup do
    WebStub.stup_ghost_blog_post
    WebStub.stub_properties_request
    WebStub.stub_redis_properties
  end

  test 'user can accces to landing page' do
    visit root_path

    assert page.has_content?('Everyone can be a homeowner')
  end

  test 'user is redirected to session path when clicking on log in' do
    visit root_path

    page.execute_script 'window.scrollBy(0,10000)'
    click_link 'Log In'

    assert page.has_content?('Sign In')
  end

  test 'user can request cher contact' do
    WebStub.stub_sendgrid_validator
    visit root_path

    within('form[data-action="submit->recaptcha#handleSubmit"]') do
      fill_in 'Name', with: 'Paul'
      fill_in 'Email', with: 'user@cher.app'
      fill_in 'Phone', with: '1113334444'
      click_button 'Submit'
    end

    assert_content 'Thank you! A member of our team will contact you asap!', wait: 5
  end

  test 'user can access to professionals section' do
    visit root_path

    page.execute_script 'window.scrollBy(0,10000)'
    click_link "I'm an Agent"

    assert_content 'Centralized Buyers Market'
  end

  test 'a new user can regitry' do
    WebStub.stub_sendgrid_validator
    WebStub.stub_sendgrid_contacts
    WebStub.stub_sendgrid_single_send
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    WebMock.stub_request(:any, %r{chat.twilio.com/v2/Services.*})
           .to_return(status: 200)
    visit root_path

    within 'section.is-main' do
      fill_in 'Sign up with your Email', with: 'new_user_@cher.app'
      click_button 'Start Now'
    end

    assert_content 'Welcome! You have signed up successfully.'
  end

  test 'user can no registry with an invalid email' do
    WebStub.stub_sendgrid_validator
    WebStub.stub_sendgrid_contacts
    WebStub.stub_sendgrid_single_send
    WebMock.stub_request(:any, %r{chat.twilio.com/v2/Services.*})
           .to_return(status: 200)
    visit root_path

    within 'section.is-main' do
      fill_in 'Sign up with your Email', with: 'borroweruser.com'
      click_button 'Start Now'
    end

    assert_no_content 'Welcome! You have signed up successfully.'
  end

  test 'user can access to professional landing page through navbar' do
    visit root_path

    page.execute_script 'window.scrollBy(0,10000)'
    click_link "I'm an Agent"

    assert_content 'Centralized Buyers Market'
  end

  test 'user logged in can see concierge chat button' do
    ChatTokensController.any_instance.stubs(:generate_token).returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    user = users(:co_borrower_user)

    sign_in user
    visit root_path

    assert find('.floating-concierge-chat-button')
  end

  test 'user not registered can see concierge chat button' do
    ChatTokensController.any_instance.stubs(:generate_token).returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    visit root_path

    assert find('.floating-concierge-chat-button')
  end
end
