# frozen_string_literal: true

class AddSearchIntentToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :search_intent, :string
  end
end
