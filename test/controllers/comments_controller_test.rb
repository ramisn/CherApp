# frozen_string_literal: true

require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @publication = publications(:co_borrower_home)
  end

  test 'it redirect no logged users' do
    post publication_comments_path(@publication), params: { comment: { body: 'Looks good' } }

    assert_redirected_to new_user_session_path
  end

  test 'it success creating a new comment' do
    login_as users(:co_borrower_user)

    assert_difference 'Comment.count', 1 do
      post publication_comments_path(@publication), params: { comment: { body: 'Looks good' } }
    end
  end

  test 'it success requesting for comment edition' do
    comment = comments(:house_comment)
    login_as users(:co_borrower_user)

    get edit_publication_comment_path(@publication, comment), params: { format: :json }

    assert_response :success
  end

  test 'it success deleting a comment' do
    comment = comments(:house_comment)
    login_as users(:co_borrower_user)

    delete publication_comment_path(@publication, comment)

    assert_redirected_to root_path
    assert 'Comment successfully deleted', flash[:notice]
  end

  test 'it success updating a comment' do
    comment = comments(:house_comment)
    login_as users(:co_borrower_user)

    put publication_comment_path(@publication, comment), params: { comment: { body: 'Updated comment' } }

    comment.reload
    assert_redirected_to root_path
    assert comment.body, 'Updated comment'
    assert 'Comment successfully updated', flash[:notice]
  end
end
