# frozen_string_literal: true

class AddPriceOnFlagToFlaggedHome < ActiveRecord::Migration[6.0]
  def change
    change_table :flagged_properties do |t|
      t.bigint :price_on_flag, null: false, default: 0
    end
  end
end
