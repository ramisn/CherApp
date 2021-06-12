# frozen_string_literal: true

class ModifySellMyInfoUser < ActiveRecord::Migration[6.0]
  def up
    change_column :users, :sell_my_info, :boolean, default: true, null: false
  end

  def down
    change_column :users, :sell_my_info, :boolean, default: false
  end
end
