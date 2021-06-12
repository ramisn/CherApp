# frozen_string_literal: true

class AddLoadDataToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :funding, :integer
    add_column :users, :co_borrowers, :integer
  end
end
