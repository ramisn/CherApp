# frozen_string_literal: true

require 'test_helper'

class UsersControllertTest < ActionDispatch::IntegrationTest
  test 'it success when requesting for user by id' do
    login_as users(:co_borrower_user)
    user = users(:co_borrower_user_2)

    get user_path(user), params: { format: :json }

    assert_response :success
  end

  test 'it success when requesting for user by email' do
    login_as users(:co_borrower_user)
    user = users(:co_borrower_user_2)

    get user_path(user.email), params: { email: user.email, format: :json }

    assert_response :success
  end

  test 'it renders not found when requesting a no registered user' do
    login_as users(:co_borrower_user)
    get user_path('invalid.user')

    assert_template :'not_found.html'
  end

  test 'not logged users can search for suggestions' do
    get users_path, params: { user: { suggestion: 'miguel' }, format: :json }

    assert_response :success
  end
end
