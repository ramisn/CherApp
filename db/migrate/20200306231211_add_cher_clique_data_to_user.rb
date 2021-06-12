# frozen_string_literal: true

class AddCherCliqueDataToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :end_of_clique, :date
  end
end
