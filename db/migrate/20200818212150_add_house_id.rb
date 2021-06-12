# frozen_string_literal: true

class AddHouseId < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :mlsid, :string
  end
end
