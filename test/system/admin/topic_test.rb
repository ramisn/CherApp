# frozen_string_literal: true

require 'application_system_test_case'

module Admin
  class DashboardTest < ApplicationSystemTestCase
    setup do
      ChatTokensController.any_instance
                          .stubs(:generate_token)
                          .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
      login_as users(:admin_user)
      visit admin_topics_path
    end

    test 'admin can view all registered topics' do
      topic = topics(:co_borrower_topic)
      assert page.has_content?(topic.name)
    end

    test 'admin can create a new topic' do
      click_link 'New topic'

      fill_in 'Topic name', with: 'A new one topic'
      page.execute_script("document.getElementById('topic_rich_body').value = 'New topic body'")
      click_button 'Create topic'

      assert page.has_content?('New topic')
    end

    test 'admin can edit a topic' do
      topic = topics(:co_borrower_topic)

      find("[href='/admin/topics/#{topic.id}/edit']").click
      fill_in 'Topic name', with: 'An edited topic'
      page.execute_script("document.getElementById('topic_rich_body').value = 'New topic body'")
      click_button 'Update topic'

      assert page.has_content?('An edited topic')
    end

    test 'admin can delete a topic' do
      topic = topics(:co_borrower_topic)
      find("[href='/admin/topics/#{topic.id}']").click
      page.driver.browser.switch_to.alert.accept

      assert page.has_content?('Topic sucessfully deleted')
    end
  end
end
