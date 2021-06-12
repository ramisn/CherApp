# frozen_string_literal: true

class CreatePropertySearches < ActiveRecord::Migration[6.0]
  def change
    create_table :property_searches do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.string :search_in, null: false
      t.string :search_type
      t.string :minprice
      t.string :maxprice
      t.string :minbeds
      t.string :minbaths
      t.string :types, array: true, default: []
      t.string :statuses, array: true, default: []
      t.string :minarea
      t.string :maxarea
      t.string :minyear
      t.string :maxyear
      t.string :minacres
      t.string :maxacres
      t.boolean :water, null: false, default: false
      t.string :maxdom
      t.string :features
      t.string :exteriorFeatures
      t.string :alias, null: false

      t.timestamps
    end
  end
end
