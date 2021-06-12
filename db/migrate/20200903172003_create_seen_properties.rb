# frozen_string_literal: true

class CreateSeenProperties < ActiveRecord::Migration[6.0]
  def change
    create_table :seen_properties do |t|
      t.belongs_to :user, foreign_key: true
      t.string :property_id, null: false

      t.timestamps
    end
  end
end
