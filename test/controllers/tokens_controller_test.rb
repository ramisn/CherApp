# frozen_string_literal: true

require 'test_helper'

class TokensControllerTest < ActionDispatch::IntegrationTest
  test 'it success when requesting for a new chat token' do
    ChatTokensController.any_instance.stubs(:generate_token).returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    login_as users(:agent_user)

    post chat_tokens_path, params: { format: :json }

    assert_response :success
  end
end
