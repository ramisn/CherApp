# frozen_string_literal: true

class AddStatusOnFlagToFlaggedProperties < ActiveRecord::Migration[6.0]
  def change
    add_column :flagged_properties, :status_on_flag, :string
  end
end
