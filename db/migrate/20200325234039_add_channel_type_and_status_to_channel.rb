# frozen_string_literal: true

class AddChannelTypeAndStatusToChannel < ActiveRecord::Migration[6.0]
  def change
    add_column :message_channels, :status, :integer, default: 0
    add_column :message_channels, :purpose, :string, default: 'conversation'
  end
end
