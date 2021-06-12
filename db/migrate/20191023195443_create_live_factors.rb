# frozen_string_literal: true

class CreateLiveFactors < ActiveRecord::Migration[6.0]
  def change
    create_table :live_factors do |t|
      t.string :question, null: false
      t.integer :weight, null: false

      t.timestamps
    end
  end
end
