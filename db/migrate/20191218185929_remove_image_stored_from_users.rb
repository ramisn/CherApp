# frozen_string_literal: true

class RemoveImageStoredFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :image_stored
  end
end
