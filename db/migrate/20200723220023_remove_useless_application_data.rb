# frozen_string_literal: true

class RemoveUselessApplicationData < ActiveRecord::Migration[6.0]
  def change
    drop_table :application_data do |t|
      t.integer :properties_in_mls
    end
  end
end
