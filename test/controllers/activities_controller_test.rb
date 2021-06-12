# frozen_string_literal: true

require 'test_helper'

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  test 'it redirect no logged user to new session path' do
    activity = activities(:join_cher)

    delete activity_path(activity)

    assert_redirected_to new_user_session_path
  end

  test 'it success requesting for activity destruction' do
    login_as users(:co_borrower_user)
    activity = activities(:join_cher)

    delete activity_path(activity)

    assert_redirected_to root_path
    assert_equal 'Activity successfully deleted', flash[:notice]
  end

  test 'it success displaying an activity' do
    login_as users(:co_borrower_user)
    activity = activities(:join_cher)

    get activity_path(activity)

    assert_response :success
  end
end
