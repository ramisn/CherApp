# frozen_string_literal: true

class ChangeSengridTypeStatusInPropescts < ActiveRecord::Migration[6.0]
  def change
    rename_column :prospects, :sendgrid_sync_status, :mailchimp_sync_status
    rename_column :users, :sendgrid_sync_status, :mailchimp_sync_status
    rename_column :prospects, :sendgrid_updated_at, :mailchimp_updated_at
    rename_column :users, :sendgrid_updated_at, :mailchimp_updated_at
  end
end
