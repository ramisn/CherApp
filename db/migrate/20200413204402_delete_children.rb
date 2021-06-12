# frozen_string_literal: true

class DeleteChildren < ActiveRecord::Migration[6.0]
  def change
    drop_table :children do |t|
      t.integer :age, null: false
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
