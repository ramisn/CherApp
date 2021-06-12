# frozen_string_literal: true

class AddGenderToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :gender, :integer
  end
end
