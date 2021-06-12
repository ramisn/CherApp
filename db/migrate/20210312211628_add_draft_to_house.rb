# frozen_string_literal: true

class AddDraftToHouse < ActiveRecord::Migration[6.0]
  def change
    add_column :houses, :draft, :boolean, default: false
  end
end
