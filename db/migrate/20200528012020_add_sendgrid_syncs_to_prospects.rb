# frozen_string_literal: true

class AddSendgridSyncsToProspects < ActiveRecord::Migration[6.0]
  def change
    add_column :prospects, :sendgrid_updated_at, :timestamp
    add_column :prospects, :sendgrid_sync_status, :integer, default: 0
  end
end
