# frozen_string_literal: true

class AddPlanTypeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :plan_type, :string
  end
end
