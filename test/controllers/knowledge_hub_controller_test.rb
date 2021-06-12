# frozen_string_literal: true

require 'test_helper'

class KnowledgeHubControllerTest < ActionDispatch::IntegrationTest
  test 'it success accessing to show action' do
    get knowledge_hub_path

    assert_response :success
  end

  test 'it success requesting with index' do
    get knowledge_hub_path, params: { index: 'a' }

    assert_response :success
  end

  test 'it success requesting with message' do
    get knowledge_hub_path, params: { topic: { message: 'buyers' } }

    assert_response :success
  end
end
