# frozen_string_literal: true

class AddPlanTypeToPayment < ActiveRecord::Migration[6.0]
  def change
    add_column :payments, :clique_plan, :string
  end
end
