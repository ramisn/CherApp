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
require 'test_helper'

class PropertyPriceTest < ActiveSupport::TestCase
  test 'is valid' do
    property_price = PropertyPrice.new(property_params)

    assert property_price.valid?
  end

  test 'is valid without price' do
    property_price = PropertyPrice.new(property_params(price: nil))

    assert property_price.valid?
  end

  test 'is invalid' do
    property_price = PropertyPrice.new(property_params(property_id: nil))

    refute property_price.valid?

    message = property_price.errors.messages[:property_id].first

    assert_equal "can't be blank", message
  end

  private

  def property_params(attrs = {})
    { property_id: '123abc', price: 2_225_000 }.merge(attrs)
  end
end
