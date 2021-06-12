# frozen_string_literal: true

class CreateNotificationSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_settings do |t|
      t.references :user, foreign_key: true
      t.boolean :accept_email, default: true
      t.boolean :accept_sms, default: true
      t.boolean :account, default: true
      t.boolean :social_network, default: true

      t.timestamps
    end

    User.all.each(&:create_notification_settings)
  end
end
