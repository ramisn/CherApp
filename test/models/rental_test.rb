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
#  for_rent_by          :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
require 'test_helper'

class RentalTest < ActiveSupport::TestCase
  def setup
    user = users(:co_borrower_user)
    @rental = Rental.new(owner: user, address: '123 Main street, Santa Monica',
                         bedrooms: 1, bathrooms: 1, state: 'CA',
                         monthly_rent: 1_000,
                         lease_duration: '1_month', phone_number: '1234567890',
                         listed_by_type: 'owner')
  end

  test 'it is not valid without owner' do
    @rental.owner = nil

    refute @rental.valid?
    assert @rental.errors[:owner].any?
  end

  test 'it is not valid without address' do
    @rental.address = nil

    refute @rental.valid?
    assert @rental.errors[:address].any?
  end

  test 'it is not valid without state' do
    @rental.state = nil

    refute @rental.valid?
    assert @rental.errors[:state].any?
  end

  test 'it is not valid without monthly rent' do
    @rental.monthly_rent = nil

    refute @rental.valid?
    assert @rental.errors[:monthly_rent].any?
  end

  test 'it is not valid without lease duration' do
    @rental.lease_duration = nil

    refute @rental.valid?
    assert @rental.errors[:lease_duration].any?
  end

  test 'it is not valid without a phone number' do
    @rental.phone_number = nil

    refute @rental.valid?
    assert @rental.errors[:phone_number].any?
  end

  test 'it is not valid without a rental by' do
    @rental.listed_by_type = nil

    refute @rental.valid?
    assert @rental.errors[:listed_by_type].any?
  end

  test 'it is valud with all attributes' do
    assert @rental.valid?
  end
end
