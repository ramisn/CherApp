# frozen_string_literal: true

require 'test_helper'

module Admin
  class ProfessionalControllerTest < ActionDispatch::IntegrationTest
    test 'it redirect no logged user to new session path' do
      get admin_professionals_path

      assert_redirected_to new_user_session_path
    end

    test 'it redirect no admins to root path' do
      login_as users(:co_borrower_user)

      get admin_professionals_path

      assert_redirected_to root_path
    end

    test 'it success when admin access to professionals section' do
      login_as users(:admin_user)

      get admin_professionals_path

      assert_response :success
    end

    test 'it success when admin update profesional info' do
      professional = users(:agent_user)
      login_as users(:admin_user)

      put admin_professional_path(professional, proffesional_verfied: true)

      assert_redirected_to admin_professionals_path
      assert 'Professional successfully udpated', flash[:notice]
    end
  end
end
