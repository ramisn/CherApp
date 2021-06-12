# frozen_string_literal: true

class CreateFriendRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :friend_requests do |t|
      t.references :requester, null: false
      t.references :requestee, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
    add_foreign_key :friend_requests, :users, column: :requester_id
    add_foreign_key :friend_requests, :users, column: :requestee_id
  end
end
