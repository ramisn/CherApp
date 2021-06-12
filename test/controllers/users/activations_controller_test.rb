# frozen_string_literal: true

require 'test_helper'

module Users
  class ActivationsControllerTest < ActionDispatch::IntegrationTest
    test 'it success requesting for activation' do
      get new_activation_path

      assert_response :success
    end

    test 'it success creating a new activation request' do
      discarded_user = users(:discarded_user)
      post activations_path, params: { activation: { email: discarded_user.email } }

      refute discarded_user.discard_token.blank?
      assert_enqueued_emails 1
    end

    test 'it success activating account' do
      discarded_user = users(:discarded_user)

      get edit_activation_path(discarded_user, discard_token: discarded_user.discard_token)

      assert_redirected_to new_user_session_path
      discarded_user.reload
      assert discarded_user.discarded_at.blank?
    end

    test 'it fails activating account with invalid token' do
      discarded_user = users(:discarded_user)

      get edit_activation_path(discarded_user, discard_token: 'invalidToken$')

      assert_redirected_to root_path
      assert discarded_user.discarded_at
    end
  end
end
