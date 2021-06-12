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

class LiveFactor < ApplicationRecord
  validates :question, :weight, :start_label, :end_label, presence: true
  enum frequency: %i[never ocasionally normally usually always]

  def self.number_of_questions
    all.count
  end
end
