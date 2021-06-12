# frozen_string_literal: true

class AddImageUrlToMessageChannel < ActiveRecord::Migration[6.0]
  def change
    change_table :message_channels do |t|
      t.string :image_url
    end
  end
end
