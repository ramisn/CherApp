# frozen_string_literal: true

class CreateHouses < ActiveRecord::Migration[6.0]
  def change
    create_table :houses do |t|
      t.references :owner, null: false, index: true, foreign_key: { to_table: :users }
      t.string :address, null: false
      t.string :state, null: false
      t.string :county
      t.integer :price, null: false
      t.integer :home_type, null: false
      t.integer :beds, null: false
      t.integer :full_baths, null: false
      t.integer :half_baths, null: false
      t.numeric :interior_area, null: false
      t.numeric :lot_size, null: false
      t.integer :year_build
      t.numeric :hoa_dues
      t.numeric :basement_area
      t.numeric :garage_area
      t.text :description
      t.text :details
      t.date :date_for_open_house
      t.time :start_hour_for_open_house
      t.time :end_hour_for_open_house
      t.string :website
      t.string :phone_contact, null: false
      t.string :email_contact, null: false
      t.integer :status, null: false, default: 0
      t.boolean :accept_terms, null: false
      t.numeric :ownership_percentage, null: false
      t.boolean :receive_analysis, null: false, default: false

      t.timestamps
    end
  end
end
