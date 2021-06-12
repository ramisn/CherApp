# frozen_string_literal: true

class Activity < ApplicationRecord
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :owner, polymorphic: true
  has_many :likes, as: :post, dependent: :destroy
  has_many :comments, as: :post, dependent: :destroy
end
