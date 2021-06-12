# frozen_string_literal: true

# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_type  :string
#  post_id    :bigint
#
require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  test 'it is not valid without a user' do
    house_comment = comments(:house_comment)
    like = Like.new(post: house_comment)

    refute like.valid?
  end

  test 'it is not valid without a post' do
    like = Like.new(user: users(:co_borrower_user))

    refute like.valid?
  end

  test 'it is valid with all atttributes' do
    house_comment = comments(:house_comment)
    like = Like.new(user: users(:co_borrower_user), post: house_comment)

    assert like.valid?
  end

  test 'it is valid related with a ublication' do
    house_comment = publications(:co_borrower_home)
    like = Like.new(user: users(:co_borrower_user), post: house_comment)

    assert like.valid?
  end
end
