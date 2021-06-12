# frozen_string_literal: true

require 'application_system_test_case'

class  KnowledgeHubTest < ApplicationSystemTestCase
  test 'user can search for a topic index' do
    visit knowledge_hub_path

    click_link 'w'

    assert page.has_content?('What a co-owner is')
  end

  test 'user can search topic by its content' do
    visit knowledge_hub_path
    fill_in 'Type something', with: 'description'
    find('#topic_message').native.send_keys(:enter)

    assert page.has_content?('What a co-owner is')
  end
end
