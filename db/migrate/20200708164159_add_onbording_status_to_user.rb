# frozen_string_literal: true

class AddOnbordingStatusToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :skip_onbording, :boolean, null: false, default: false
  end
end
