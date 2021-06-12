# frozen_string_literal: true

# == Schema Information
#
# Table name: property_prices
#
#  id          :bigint           not null, primary key
#  property_id :string           not null
#  price       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class PropertyPrice < ApplicationRecord
  validates :property_id, presence: true
end
