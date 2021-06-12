# frozen_string_literal: true

class CreateApplicationData < ActiveRecord::Migration[6.0]
  def change
    create_table :application_data do |t|
      t.integer :properties_in_mls
    end
  end
end
