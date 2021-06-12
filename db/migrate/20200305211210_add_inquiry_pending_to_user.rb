# frozen_string_literal: true

class AddInquiryPendingToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :inquiry_pending, :boolean, null: false, default: false
  end
end
