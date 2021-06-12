# frozen_string_literal: true

require 'test_helper'

class ShapesControllertTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:co_borrower_user)

    login_as @user
  end

  test 'it succeeds when posting a shape' do
    post shapes_path(format: :json), params: { shape: shape_properties }

    assert_response :success
  end

  test 'it errors when posting a shape without name' do
    post shapes_path(format: :json), params: { shape: shape_properties(name: nil) }

    assert_response :unprocessable_entity
  end

  test 'it succeeds when updating a shape' do
    shape = shapes(:shape_one)

    put shape_path(shape.id, format: :json), params: { shape: shape_properties(name: 'Santa monica 2') }

    assert_response :success
  end

  test 'it succeeds when deleting a shape' do
    shape = shapes(:shape_one)

    delete shape_path(shape.id)

    assert_response 204
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
