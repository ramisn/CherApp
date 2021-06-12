# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.string :transaction_id, null: false
      t.belongs_to :user, null: false, foreign_key: true
      t.string :receipt_url, null: false
      t.integer :amount, null: false

      t.timestamps
    end
  end
end
