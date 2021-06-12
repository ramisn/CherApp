# frozen_string_literal: true

require 'application_system_test_case'

class CommentsTest < ApplicationSystemTestCase
  def setup
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    WebStub.stub_properties_request
    WebStub.stup_ghost_blog_post
    login_as users(:co_borrower_user)
    visit co_borrower_dashboard_path
    page.execute_script 'window.scrollBy(0,10000)'
  end

  test 'user can comment a publication' do
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    WebStub.stub_properties_request
    WebStub.stup_ghost_blog_post
    first('ul .input.is-transparent').fill_in(with: 'If there is someone interested, please contact me')
    first('ul .input.is-transparent').native.send_keys(:return)

    assert_content 'Comment was sucessfully created'
    assert_content 'If there is someone interested, please contact me'
  end

  test 'user can edit a comment' do
    first('ul .comment-container .options-container').hover
    first('ul .comment-container .options-container .button').click
    first('.modal textarea').fill_in(with: 'Edited comment')
    click_button 'Update'

    assert_content 'Comment successfully updated'
  end

  test 'user can delete a comment' do
    first('ul .comment-container .options-container').hover
    first('ul .comment-container .options-container a').click
    page.driver.browser.switch_to.alert.accept

    assert_content 'Comment successfully deleted'
  end
end
