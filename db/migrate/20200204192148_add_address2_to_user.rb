# frozen_string_literal: true

class AddAddress2ToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :address2, :string
  end
end
