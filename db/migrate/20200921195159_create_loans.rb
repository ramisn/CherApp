# frozen_string_literal: true

class CreateLoans < ActiveRecord::Migration[6.0]
  def change
    create_table :loans do |t|
      t.belongs_to :user, foreign_key: true
      t.string :property_id
      t.string :property_street
      t.string :property_city
      t.string :property_state
      t.string :property_zipcode
      t.string :property_county
      t.string :property_type
      t.boolean :property_occupied
      t.boolean :first_home, null: false
      t.boolean :live_there, null: false
      t.integer :status, null: false, default: 0
      t.string :unique_code

      t.timestamps
    end

    create_table :loan_participants do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :loan, foreign_key: true
      t.boolean :accepted_request, null: false, default: false
      t.string :token
    end
  end
end
