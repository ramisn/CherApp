# frozen_string_literal: true

class AddCityToWatchedProperties < ActiveRecord::Migration[6.0]
  def change
    add_column :watched_properties, :city, :string, null: false, default: ''
  end
end
