# frozen_string_literal: true

class AddProffesionalVerifiedToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :proffesional_verfied, :boolean, default: false
  end
end
