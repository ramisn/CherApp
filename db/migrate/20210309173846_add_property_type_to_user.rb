# frozen_string_literal: true

class AddPropertyTypeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :property_type, :integer
  end
end
