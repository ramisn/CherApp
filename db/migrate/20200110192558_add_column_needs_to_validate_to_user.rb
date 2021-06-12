# frozen_string_literal: true

class AddColumnNeedsToValidateToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :needs_verification, :boolean, null: false, default: false
  end
end
