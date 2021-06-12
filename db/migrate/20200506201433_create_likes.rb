# frozen_string_literal: true

class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.references :user, index: true, foreign_key: { to_table: :users }
      t.references :activity, index: true, foreign_key: { to_table: :activities }

      t.timestamps
    end
  end
end
