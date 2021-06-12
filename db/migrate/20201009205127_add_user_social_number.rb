# frozen_string_literal: true

class AddUserSocialNumber < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :ssn, :string
  end
end
