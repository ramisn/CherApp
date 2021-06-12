# frozen_string_literal: true

class CreateHouseUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :houses_users do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :house, foreign_key: true
    end
  end
end
