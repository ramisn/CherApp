# frozen_string_literal: true

class AddMessageCreditsToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.integer :message_credits, null: false, default: 0
    end
  end
end
