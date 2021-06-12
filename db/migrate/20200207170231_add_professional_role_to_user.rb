# frozen_string_literal: true

class AddProfessionalRoleToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :professional_role, :integer
  end
end
