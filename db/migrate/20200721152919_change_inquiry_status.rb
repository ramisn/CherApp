# frozen_string_literal: true

class ChangeInquiryStatus < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :background_check_status, :integer, default: 0
  end
end
