# frozen_string_literal: true

# == Schema Information
#
# Table name: payments
#
#  id             :bigint           not null, primary key
#  transaction_id :string           not null
#  user_id        :bigint           not null
#  receipt_url    :string           not null
#  amount         :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  clique_plan    :string
#

class Payment < ApplicationRecord
  belongs_to :user
  validates_presence_of :transaction_id, :receipt_url, :amount
end
