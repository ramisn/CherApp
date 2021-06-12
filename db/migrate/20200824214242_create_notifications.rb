# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :owner, index: true, foreign_key: { to_table: :users }
      t.references :recipient, index: true, foreign_key: { to_table: :users }, null: false
      t.string :key, null: false
      t.integer :status, null: false, default: 0
      t.json :params

      t.timestamps
    end
  end
end
