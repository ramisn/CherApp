# frozen_string_literal: true

class AddColumnPesonalityTestTries < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :test_attempts, :integer, null: false, default: 0
    add_column :users, :test_blocked_till, :date
  end
end
