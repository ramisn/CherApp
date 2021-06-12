# frozen_string_literal: true

class AddSendgridSyncsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :sendgrid_updated_at, :timestamp
    add_column :users, :sendgrid_sync_status, :integer, default: 0
  end
end
