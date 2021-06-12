# frozen_string_literal: true

class AddDiscardToken < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :discard_token, :string
  end
end
