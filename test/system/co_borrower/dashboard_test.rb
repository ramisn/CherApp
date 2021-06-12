# frozen_string_literal: true

require 'application_system_test_case'

class DashboardTest < ApplicationSystemTestCase
  setup do
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    WebStub.stup_ghost_blog_post
    WebStub.stub_redis_properties
  end

  test 'no logged user cannot see link to dashboard' do
    sign_out :user
    visit root_path
    page.execute_script 'window.scrollBy(0,10000)'

    assert has_no_css?('.go-profile')
  end

  test 'logged agent user can see link to dashboard' do
    agent_user = users(:agent_user)

    sign_in agent_user
    visit root_path
    page.execute_script 'window.scrollBy(0,10000)'

    assert first('.go-profile')
  end

  test 'logged co borrower user can see link to dashboard' do
    sign_in users(:co_borrower_user)

    visit root_path
    page.execute_script 'window.scrollBy(0,10000)'

    assert first('.go-profile')
  end

  test 'logged user can access to dashboard' do
    co_borrower_user = users(:co_borrower_user)
    sign_in co_borrower_user
    visit root_path
    page.execute_script 'window.scrollBy(0,10000)'
    find('.go-profile').hover

    click_link 'Dashboard'

    assert page.has_content? co_borrower_user.full_name
  end

  test 'user can see notification section' do
    WebStub.stub_properties_request
    co_borrower_user = users(:co_borrower_user)

    sign_in co_borrower_user
    visit root_path
    page.execute_script 'window.scrollBy(0,10000)'
    find('.go-profile').hover
    click_link 'Dashboard'

    assert page.has_content?('Notifications')
  end

  test 'user is redirected to My Friends when Contacting Realtor' do
    ProfessionalContactService.any_instance
                              .stubs(:execute)
                              .returns
    WebMock.stub_request(:any, /chat.twilio.com.*/)
           .to_return(status: 200, body: '')
    WebMock.stub_request(:any, /api.sendgrid.com.*/)
           .to_return(status: 200, body: '')
    co_borrower_user = users(:co_borrower_user)
    sign_in co_borrower_user
    visit root_path
    page.execute_script 'window.scrollBy(0,10000)'
    find('.go-profile').hover

    click_link 'Dashboard'
    click_link 'Contact a Realtor'

    assert_content "Friends you'd like to buy with", wait: 5
  end
end
