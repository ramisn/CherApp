# frozen_string_literal: true

# == Schema Information
#
# Table name: prospects
#
#  id             :integer          not null, primary key
#  email          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  is_subscribed  :boolean          default("true"), not null
#  marked_as_spam :boolean          default("false"), not null
#  bounced        :boolean          default("false"), not null
#  role           :integer          default("0")
#

require 'test_helper'

class ProspectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
