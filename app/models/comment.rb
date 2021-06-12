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
class Comment < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :post, polymorphic: true
  has_many :likes, as: :post, dependent: :destroy

  validates :body, presence: true
end
