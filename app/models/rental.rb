# frozen_string_literal: true

# == Schema Information
#
# Table name: rentals
#
#  id                   :bigint           not null, primary key
#  user_id              :bigint
#  address              :string           not null
#  state                :string           not null
#  monthly_rent         :integer          not null
#  security_deposit     :integer
#  bedrooms             :integer          not null
#  bathrooms            :integer          not null
#  square_feet          :integer
#  date_available       :date
#  lease_duration       :integer          not null
#  hide_address         :boolean          default("false")
#  ac                   :boolean
#  balcony_or_deck      :boolean
#  furnished            :boolean
#  hardwood_floor       :boolean
#  wheelchair_access    :boolean
#  garage_parking       :boolean
#  off_street_parking   :boolean
#  additional_amenities :string
#  laundry              :integer
#  permit_pets          :boolean
#  permit_cats          :boolean
#  permit_small_dogs    :boolean
#  permit_large_dogs    :boolean
#  about                :text
#  lease_summary        :text
#  name                 :string
#  phone_number         :string           not null
#  email                :string
#  listed_by_type       :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Rental < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many_attached :images

  enum lease_duration: %i[1_month 6_months 1_year rent_to_own sublet_temporary]
  enum laundry: %i[no in_unit shared]
  enum listed_by_type: %i[owner company tenant]
  enum status: %i[pending approved rejected]

  validates :address, length: { in: 10..40 }
  validates :monthly_rent, numericality: { greater_than: 0 }
  validates :bedrooms, presence: true, numericality: { greater_than: 0 }
  validates :bathrooms, presence: true, numericality: { greater_than: 0 }
  validates :phone_number, length: { is: 10 }
  validates :images, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 10.megabytes }
  validates_presence_of :address, :state, :monthly_rent, :bedrooms,
                        :bathrooms, :lease_duration, :phone_number,
                        :listed_by_type
end
