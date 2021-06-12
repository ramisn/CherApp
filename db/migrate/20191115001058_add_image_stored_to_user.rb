# frozen_string_literal: true

class AddImageStoredToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :image_stored, :string
  end
end
