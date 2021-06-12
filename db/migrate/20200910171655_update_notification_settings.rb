# frozen_string_literal: true

class UpdateNotificationSettings < ActiveRecord::Migration[6.0]
  def change
    remove_column :notification_settings, :accept_email, :boolean, default: true
    remove_column :notification_settings, :accept_sms, :boolean, default: true
    remove_column :notification_settings, :account, :boolean, default: true
    remove_column :notification_settings, :social_network, :boolean, default: true
    add_column :notification_settings, :preferences, :json, default: {}
  end
end
