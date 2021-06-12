# frozen_string_literal: true

# == Schema Information
#
# Table name: houses
#
#  id                        :bigint           not null, primary key
#  owner_id                  :bigint           not null
#  address                   :string
#  state                     :string
#  county                    :string
#  price                     :integer
#  home_type                 :integer
#  beds                      :integer
#  full_baths                :integer
#  half_baths                :integer
#  interior_area             :decimal(, )
#  lot_size                  :decimal(, )
#  year_build                :integer
#  hoa_dues                  :decimal(, )
#  basement_area             :decimal(, )
#  garage_area               :decimal(, )
#  description               :text
#  details                   :text
#  date_for_open_house       :date
#  start_hour_for_open_house :time
#  end_hour_for_open_house   :time
#  website                   :string
#  phone_contact             :string
#  email_contact             :string
#  status                    :integer          default("0"), not null
#  accept_terms              :boolean
#  ownership_percentage      :decimal(, )
#  receive_analysis          :boolean          default("false"), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  selling_percentage        :integer          default("0"), not null
#  down_payment              :integer          default("0"), not null
#  monthly_mortgage          :integer          default("0"), not null
#  mlsid                     :string
#  draft                     :boolean          default("false")
#
require 'test_helper'

class HouseTest < ActiveSupport::TestCase
  setup do
    user = users(:co_borrower_user)
    @house = House.new(owner: user, address: '123 Main Street',
                       state: 'CA', county: 'Alameda', price: 200_000,
                       home_type: :condo, beds: 1, full_baths: 2,
                       half_baths: 1, lot_size: 200, interior_area: 100,
                       year_build: 1990, accept_terms: true,
                       phone_contact: '1232287965', ownership_percentage: 10,
                       email_contact: 'user@email.com', status: :pending)
  end

  test 'it is not valid if terms are not accepted' do
    @house.accept_terms = false

    refute @house.valid?
    assert @house.errors[:accept_terms].any?
  end

  test 'it is not valid without interior_area' do
    @house.interior_area = nil

    refute @house.valid?
    assert @house.errors[:interior_area].any?
  end

  test 'it is not valid withput ownership_percentage' do
    @house.ownership_percentage = nil

    refute @house.valid?
    assert @house.errors[:ownership_percentage].any?
  end

  test 'it is not valid without an owner' do
    @house.owner = nil

    refute @house.valid?
    assert @house.errors[:owner].any?
  end

  test 'it is not valid without address' do
    @house.address = nil

    refute @house.valid?
    assert @house.errors[:address].any?
  end

  test 'it is not valid without state' do
    @house.state = nil

    refute @house.valid?
    assert @house.errors[:state].any?
  end

  test 'it is not valid without price' do
    @house.price = nil

    refute @house.valid?
    assert @house.errors[:price].any?
  end

  test 'it is not valid without type' do
    @house.home_type = nil

    refute @house.valid?
    assert @house.errors[:home_type].any?
  end

  test 'it is not valid without beds' do
    @house.beds = nil

    refute @house.valid?
    assert @house.errors[:beds].any?
  end

  test 'it is not valid without full baths' do
    @house.full_baths = nil

    refute @house.valid?
    assert @house.errors[:full_baths].any?
  end

  test 'it is not valid without phone contact' do
    @house.phone_contact = nil

    refute @house.valid?
    assert @house.errors[:phone_contact].any?
  end

  test 'it is valid with all attributes' do
    assert @house.valid?
  end

  test 'it can be saved as a draft' do
    house = House.new(owner: users(:co_borrower_user), address: '123 Main Street',
                      state: 'CA', county: 'Alameda', price: 200_000,
                      email_contact: 'user@email.com', draft: true)

    assert house.valid?
  end
end
