# frozen_string_literal: true

class ChangeUserAreasType < ActiveRecord::Migration[6.0]
  def up
    change_column :users, :areas, :string, default: [], array: true, using: "(string_to_array(areas, ','))"
  end

  def down
    change_column :users, :areas, :string, default: nil, array: false, using: "(array_to_string(areas, ','))"
  end
end
