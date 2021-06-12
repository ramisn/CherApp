# frozen_string_literal: true

class CreateShapes < ActiveRecord::Migration[6.0]
  def change
    create_table :shapes do |t|
      t.string :name, null: false
      t.integer :shape_type, null: false, default: 0
      t.float :radius, default: 0
      t.jsonb :center, default: '[]'
      t.jsonb :coordinates, default: '[]'
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
