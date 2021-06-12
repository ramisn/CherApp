# frozen_string_literal: true

class AddSlugToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :slug, :string, null: false, default: ''
    specify_users_slug
    add_index :users, :slug, unique: true
  end

  private

  def specify_users_slug
    User.all.each do |user|
      user.set_slug
      user.save
    end
  end
end
