# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :owner, index: true, foreign_key: { to_table: :users }
      t.references :activity, index: true, foreign_key: { to_table: :activities }

      t.timestamps
    end
  end
end
