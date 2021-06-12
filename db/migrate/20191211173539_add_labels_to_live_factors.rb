# frozen_string_literal: true

class AddLabelsToLiveFactors < ActiveRecord::Migration[6.0]
  def change
    add_column :live_factors, :start_label, :string
    add_column :live_factors, :end_label, :string
  end
end
