# frozen_string_literal: true

# == Schema Information
#
# Table name: contacts
#
#  id               :bigint           not null, primary key
#  status           :integer          default("0")
#  contactable_id   :integer
#  contactable_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
