# frozen_string_literal: true

class AddExtraInformationToHouse < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :selling_percentage, :integer, null: false, default: 0
    add_column :houses, :down_payment, :integer, null: false, default: 0
    add_column :houses, :monthly_mortgage, :integer, null: false, default: 0
  end
end
