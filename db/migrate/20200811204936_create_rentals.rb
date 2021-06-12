# frozen_string_literal: true

class CreateRentals < ActiveRecord::Migration[6.0]
  def change
    create_table :rentals do |t|
      t.references :owner, null: false, index: true, foreign_key: { to_table: :users }
      t.string :address, null: false
      t.string :state, null: false
      t.integer :monthly_rent, null: false
      t.integer :security_deposit
      t.integer :bedrooms, null: false
      t.integer :bathrooms, null: false
      t.integer :square_feet
      t.date :date_available
      t.integer :lease_duration, null: false
      t.boolean :hide_address, default: false
      t.boolean :ac
      t.boolean :balcony_or_deck
      t.boolean :furnished
      t.boolean :hardwood_floor
      t.boolean :wheelchair_access
      t.boolean :garage_parking
      t.boolean :off_street_parking
      t.string :additional_amenities
      t.integer :laundry
      t.boolean :permit_pets
      t.boolean :permit_cats
      t.boolean :permit_small_dogs
      t.boolean :permit_large_dogs
      t.text :about
      t.text :lease_summary
      t.string :name
      t.string :phone_number, null: false
      t.string :email
      t.integer :listed_by_type, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
