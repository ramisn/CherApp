# frozen_string_literal: true

# == Schema Information
#
# Table name: responses
#
#  id             :integer          not null, primary key
#  user_id        :integer          not null
#  live_factor_id :integer          not null
#  response       :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Response < ApplicationRecord
  belongs_to :user
  belongs_to :live_factor

  validates_presence_of :response
end
