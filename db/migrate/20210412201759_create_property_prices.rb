# frozen_string_literal: true

class CreatePropertyPrices < ActiveRecord::Migration[6.0]
  def change
    create_table :property_prices do |t|
      t.string :property_id, null: false
      t.integer :price

      t.timestamps
    end
  end
end
