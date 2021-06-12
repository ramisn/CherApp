# frozen_string_literal: true

class CreatePromoCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :promo_codes do |t|
      t.string :name, null: false
      t.string :class_name, null: false
      t.date :expiration
      t.timestamps
    end

    create_table :promo_codes_users, id: false do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :promo_code, foreign_key: true
    end
  end
end
