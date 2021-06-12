# frozen_string_literal: true

require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @co_borrower_publication = publications(:co_borrower_home)
    @activity = activities(:join_cher)
  end

  test 'it redirects no logged user' do
    post activity_likes_path(@activity)

    assert_redirected_to new_user_session_path
  end

  test 'it success creating a like with a comment' do
    login_as users(:co_borrower_user)

    assert_difference 'Like.count', 1 do
      post activity_likes_path(@activity)
    end
  end

  test 'it success creating a like with a publication' do
    login_as users(:co_borrower_user)

    assert_difference 'Like.count', 1 do
      post publication_likes_path(@co_borrower_publication)
    end
  end

  test 'it success deleting a comment like' do
    like = likes(:join_cher)
    login_as users(:co_borrower_user)

    assert_difference 'Like.count', -1 do
      delete activity_like_path(@activity, like)
    end
  end

  test 'it success deleting a publication like' do
    like = likes(:house_publication)
    login_as users(:co_borrower_user)

    assert_difference 'Like.count', -1 do
      delete publication_like_path(@co_borrower_publication, like)
    end
  end
end
