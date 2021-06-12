# frozen_string_literal: true

class AddMiddlenameAndDobToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :middle_name, :string
    add_column :users, :date_of_birth, :date
  end
end
