# frozen_string_literal: true

# == Schema Information
#
# Table name: promo_codes
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  class_name :string           not null
#  expiration :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'test_helper'

class PromoCodeTest < ActiveSupport::TestCase
  test 'it is not valid without name' do
    code = PromoCode.new

    refute code.valid?
  end

  test 'it is not valid without class name' do
    code = PromoCode.new(name: 'Free')

    refute code.valid?
  end

  test 'it is valid with name and class_name' do
    code = PromoCode.new(name: 'Free', class_name: 'FreeClass')

    assert code.valid?
  end
end
