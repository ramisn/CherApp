# frozen_string_literal: true

class AddDeletedAtToNotification < ActiveRecord::Migration[6.0]
  def change
    change_table :notifications do |t|
      t.datetime :deleted_at
    end
  end
end
