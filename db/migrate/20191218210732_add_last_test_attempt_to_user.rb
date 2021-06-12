# frozen_string_literal: true

class AddLastTestAttemptToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :test_reset_period, :date, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
