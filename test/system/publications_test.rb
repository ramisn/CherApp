# frozen_string_literal: true

require 'application_system_test_case'

class PublicationsTest < ApplicationSystemTestCase
  def setup
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    WebStub.stub_properties_request
    WebStub.stup_ghost_blog_post
    login_as users(:co_borrower_user)
  end

  test 'user can create a publication' do
    visit co_borrower_dashboard_path
    fill_in 'Share something...', with: 'Looking for a co-owner'
    click_button 'Publish'

    assert_content 'Publication successfully created'
    assert_content 'Looking for a co-owner'
  end

  test 'user can edit its publication' do
    visit co_borrower_dashboard_path

    page.execute_script 'window.scrollBy(0,10000)'
    first('ul li.post .options-container').hover
    first('ul li.post .options-container .button').click
    within('#editPublicationModal') do
      fill_in 'publication[message]', with: 'Edited post'
      click_button 'Save'
    end

    assert_content 'Edited post'
    assert_content 'Publication sucessfully updated'
  end
end
