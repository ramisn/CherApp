# frozen_string_literal: true

class CreateMessageChannels < ActiveRecord::Migration[6.0]
  def change
    create_table :message_channels do |t|
      t.string :sid
      t.string :participants, array: true, default: []

      t.timestamps
    end
  end
end
