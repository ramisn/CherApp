# frozen_string_literal: true

class CreateAreas < ActiveRecord::Migration[6.0]
  def change
    create_table :areas do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
