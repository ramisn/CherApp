# frozen_string_literal: true

class AddFeedbackPlanFinishedToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.integer :feedback_plan_step, default: 0
    end
  end
end
