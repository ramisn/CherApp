# frozen_string_literal: true

class AddCityToSeenProperty < ActiveRecord::Migration[6.0]
  def change
    change_table :seen_properties do |t|
      t.string :city, default: '', null: false
    end
  end
end
