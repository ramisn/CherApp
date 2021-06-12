# frozen_string_literal: true

# == Schema Information
#
# Table name: saved_searches
#
#  id               :bigint           not null, primary key
#  user_id          :bigint           not null
#  search_in        :string           not null
#  minprice         :string
#  maxprice         :string
#  minbeds          :string
#  minbaths         :string
#  type             :string
#  status           :string
#  minarea          :string
#  maxarea          :string
#  minyear          :string
#  maxyear          :string
#  minacres         :string
#  maxacres         :string
#  water            :string
#  max_dom          :string
#  feature          :string
#  exteriorFeatures :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class PropertySearch < ApplicationRecord
  belongs_to :user
  validates :search_in, presence: true
  validate :maximum_number_of_searches
  scope :with_types, ->(types) { where('types @> ARRAY[?]::varchar[] AND ARRAY[?]::varchar[] @> types', types, types) }
  scope :with_statuses, ->(statuses) { where('statuses @> ARRAY[?]::varchar[] AND ARRAY[?]::varchar[] @> statuses', statuses, statuses) }

  def maximum_number_of_searches
    return if user.property_searches.size <= 5

    errors.add(:size, I18n.t('property_searches.errors.size'))
  end
end
