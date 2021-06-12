# frozen_string_literal: true

class CreateResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :responses do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :question, null: false
      t.integer :response, null: false

      t.timestamps
    end
  end
end
