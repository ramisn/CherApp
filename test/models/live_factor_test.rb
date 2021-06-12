# frozen_string_literal: true

# == Schema Information
#
# Table name: live_factors
#
#  id          :integer          not null, primary key
#  question    :string           not null
#  weight      :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  start_label :string
#  end_label   :string
#

require 'test_helper'

class LiveFactorTest < ActiveSupport::TestCase
  test 'live factor is not valid with no question attribute' do
    live_factor = LiveFactor.new(weight: 5)

    refute live_factor.valid?
  end

  test 'live factor is not valid with no weight attribute' do
    live_factor = LiveFactor.new(question: "Would you say you're a neat person?")

    refute live_factor.valid?
  end

  test 'live factor is not valid with only question and weight attributes' do
    live_factor = LiveFactor.new(question: "Would you say you're a neat person?", weight: 5)

    refute live_factor.valid?
  end

  test 'live factor is valid with all attributes' do
    live_factor = LiveFactor.new(question: "Would you say you're a neat person?",
                                 weight: 5,
                                 start_label: 'I can never find anything.',
                                 end_label: 'Did you just drop that?')

    assert live_factor.valid?
  end
end
