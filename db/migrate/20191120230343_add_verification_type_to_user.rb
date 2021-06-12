# frozen_string_literal: true

class AddVerificationTypeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :verification_type, :string
  end
end
