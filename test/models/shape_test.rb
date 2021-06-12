# frozen_string_literal: true

# == Schema Information
#
# Table name: shapes
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  shape_type  :integer          default("0"), not null
#  radius      :float            default("0.0")
#  center      :jsonb
#  coordinates :jsonb
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'test_helper'

class ShapeTest < ActiveSupport::TestCase
  test 'is valid' do
    shape = Shape.create(shape_properties)

    assert shape.valid?
  end

  test 'is invalid without name' do
    shape = Shape.create(shape_properties(name: nil))

    refute shape.valid?
  end

  test 'user can only hav a maximum of 16 shapes' do
    user = users(:co_borrower_user)

    (1..17).each { |s| Shape.create(shape_properties(name: "Shape #{s}")) }

    assert user.shapes.count == 16

    shape = Shape.create(shape_properties(name: 'Shape 17'))

    refute shape.valid?
    assert_equal I18n.t('activerecord.errors.shapes.maximum_saved'), shape.errors[:user].first
  end

  private

  def shape_properties(attrs = {})
    {
      shape_type: 'rectangle',
      name: 'Santa Monica',
      user_id: users(:co_borrower_user).id,
      coordinates: [
        { 'lat': 34.03302759195899, 'lng': -118.47509623803711 },
        { 'lat': 34.038006488942266, 'lng': -118.48350764550781 },
        { 'lat': 34.02847520185939, 'lng': -118.48350764550781 }
      ]
    }.merge(attrs)
  end
end
