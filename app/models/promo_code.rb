# frozen_string_literal: true

# == Schema Information
#
# Table name: promo_codes
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  class_name :string           not null
#  expiration :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PromoCode < ApplicationRecord
  has_and_belongs_to_many :users
  validates_presence_of :name, :class_name
end
