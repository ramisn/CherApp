# frozen_string_literal: true

class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.integer :status, default: 0
      t.integer :contactable_id
      t.string :contactable_type

      t.timestamps
    end
  end
end
