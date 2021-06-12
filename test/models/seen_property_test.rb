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
#
require 'test_helper'

class SeenPropertyTest < ActiveSupport::TestCase
  test 'it is not valid without a property id' do
    seen_property = SeenProperty.new(user: users(:co_borrower_user))

    refute seen_property.valid?
    assert seen_property.errors[:property_id].any?
  end

  test 'it is not valid without a user' do
    seen_property = SeenProperty.new(property_id: '123asd')

    refute seen_property.valid?
    assert seen_property.errors[:user].any?
  end
end
