# frozen_string_literal: true

# == Schema Information
#
# Table name: seen_properties
#
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  property_id :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  city        :string           not nul

class SeenProperty < ApplicationRecord
  belongs_to :user
  validates_presence_of :property_id, :city

  scope :by_city, ->(city) { where(city: city) }
  scope :last_seen, ->(date) { where('created_at > ?', date) }
  scope :grouped_by_property, -> { group('property_id') }
  scope :ordered_by_seen, -> { order(Arel.sql('COUNT(*) DESC')) }
end
