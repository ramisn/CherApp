# frozen_string_literal: true

class ChangeHouseConstraints < ActiveRecord::Migration[6.0]
  def up
    change_column :houses, :address, :string, null: true
    change_column :houses, :state, :string, null: true
    change_column :houses, :price, :integer, null: true
    change_column :houses, :home_type, :integer, null: true
    change_column :houses, :beds, :integer, null: true
    change_column :houses, :full_baths, :integer, null: true
    change_column :houses, :half_baths, :integer, null: true
    change_column :houses, :interior_area, :numeric, null: true
    change_column :houses, :lot_size, :numeric, null: true
    change_column :houses, :phone_contact, :string, null: true
    change_column :houses, :email_contact, :string, null: true
    change_column :houses, :accept_terms, :boolean, null: true
    change_column :houses, :ownership_percentage, :numeric, null: true
  end

  def down
    change_column :houses, :address, :string, null: false
    change_column :houses, :state, :string, null: false
    change_column :houses, :price, :integer, null: false
    change_column :houses, :home_type, :integer, null: false
    change_column :houses, :beds, :integer, null: false
    change_column :houses, :full_baths, :integer, null: false
    change_column :houses, :half_baths, :integer, null: false
    change_column :houses, :interior_area, :numeric, null: false
    change_column :houses, :lot_size, :numeric, null: false
    change_column :houses, :phone_contact, :string, null: false
    change_column :houses, :email_contact, :string, null: false
    change_column :houses, :accept_terms, :boolean, null: false
    change_column :houses, :ownership_percentage, :numeric, null: false
  end
end
