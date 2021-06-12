# frozen_string_literal: true

class AddRoleToSubscribers < ActiveRecord::Migration[6.0]
  def change
    add_column :subscribers, :role, :integer, default: 0
  end
end
