# frozen_string_literal: true

class ChangeColumnNameUserCompanyDescription < ActiveRecord::Migration[6.0]
  def up
    rename_column :users, :company_description, :address1
  end

  def down
    rename_column :users, :address1, :company_description
  end
end
