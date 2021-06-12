# frozen_string_literal: true

class AddNumberLicenseToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :number_license, :string
  end
end
