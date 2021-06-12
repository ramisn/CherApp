# frozen_string_literal: true

class AddDontSellMyInfoToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :sell_my_info, :boolean, default: false
  end
end
