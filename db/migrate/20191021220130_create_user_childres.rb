# frozen_string_literal: true

class CreateUserChildres < ActiveRecord::Migration[6.0]
  def change
    create_table :children do |t|
      t.integer :age, null: false
      t.belongs_to :user

      t.timestamps
    end
  end
end
