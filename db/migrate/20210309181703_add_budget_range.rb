# frozen_string_literal: true

class AddBudgetRange < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.integer :budget_from
      t.integer :budget_to
    end
  end
end
