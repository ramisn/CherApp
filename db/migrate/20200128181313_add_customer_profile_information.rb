# frozen_string_literal: true

class AddCustomerProfileInformation < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :description, :string
    add_column :users, :company_name, :string
    add_column :users, :company_description, :string
    add_column :users, :areas, :string
  end
end
