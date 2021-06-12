# frozen_string_literal: true

class AddReferralDataToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :referral_code, :string
  end
end
