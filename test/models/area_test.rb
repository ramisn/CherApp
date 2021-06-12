# frozen_string_literal: true
# == Schema Information
#
# Table name: areas
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# frozen_string_literal: true

require 'test_helper'

class AreaTest < ActiveSupport::TestCase
  test 'area is not valit without name' do
    adelanto = Area.new

    refute adelanto.valid?
  end

  test 'area is valid with a name' do
    adelanto = Area.new(name: 'Adelatro')

    assert adelanto.valid?
  end
end
