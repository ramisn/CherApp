# frozen_string_literal: true

class ChangeResponseReferenceColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :responses, :question_id, :live_factor_id
  end
end
