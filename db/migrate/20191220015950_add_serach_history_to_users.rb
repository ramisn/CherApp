# frozen_string_literal: true

class AddSerachHistoryToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :search_history, :string, array: true, default: []
  end
end
