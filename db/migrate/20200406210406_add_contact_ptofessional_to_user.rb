# frozen_string_literal: true

class AddContactPtofessionalToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :contact_professional, :boolean, default: false, null: false
  end
end
