# frozen_string_literal: true

class AddFirstNameAdnCityToProspect < ActiveRecord::Migration[6.0]
  def change
    add_column :prospects, :first_name, :string
    add_column :prospects, :city, :string
  end
end
