# frozen_string_literal: true

class CreateWatchedProperties < ActiveRecord::Migration[6.0]
  def change
    create_table :watched_properties do |t|
      t.string :property_id, index: true, null: false
      t.references :user, index: true, null: false

      t.timestamps
    end
  end
end
