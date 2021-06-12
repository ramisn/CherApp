# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id          :bigint           not null, primary key
#  body        :text
#  owner_id    :bigint
#  activity_id :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup do
    @publication = publications(:co_borrower_home)
    @user = users(:co_borrower_user)
  end

  test 'comment is not valid without a owner' do
    comment = Comment.new(body: 'Looks good', post: @publication)

    refute comment.valid?
  end

  test 'comment is not valid without a body' do
    comment = Comment.new(owner: @user, post: @publication)

    refute comment.valid?
  end

  test 'comment is not valid without a postt' do
    comment = Comment.new(owner: @user, body: 'Looks good')

    refute comment.valid?
  end

  test 'comment is valid with all attributes' do
    comment = Comment.new(owner: @user, body: 'Looks good', post: @publication)

    assert comment.valid?
  end
end
