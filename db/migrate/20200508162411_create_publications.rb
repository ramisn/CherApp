# frozen_string_literal: true

class CreatePublications < ActiveRecord::Migration[6.0]
  def change
    create_table :publications do |t|
      t.references :owner, index: true, foreign_key: { to_table: :users }
      t.text :message

      t.timestamps
    end
  end
end
