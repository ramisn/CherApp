# frozen_string_literal: true

class AddPointsToPropertySearches < ActiveRecord::Migration[6.0]
  def change
    change_table :property_searches do |t|
      t.jsonb :points, default: '[]'
    end
  end
end
