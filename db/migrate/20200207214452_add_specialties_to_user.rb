# frozen_string_literal: true

class AddSpecialtiesToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :specialties, :string, array: true, default: []
  end
end
