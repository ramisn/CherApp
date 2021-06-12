# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.uuid :uuid, null: false
      t.string :title
      t.string :feature_image
      t.string :plaintext
      t.string :slug

      t.timestamps
    end
  end
end
