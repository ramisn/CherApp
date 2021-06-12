# frozen_string_literal: true

class DeleteInquiryPending < ActiveRecord::Migration[6.0]
  def up
    User.all.each do |user|
      if user.funding.blank?
        status = user.inquiry_pending ? :pending : :no_requested
        user.update(background_check_status: status)
      else
        user.update(background_check_status: :approved)
      end
    end
    remove_column :users, :inquiry_pending
  end

  def down
    add_column :users, :inquiry_pending, :boolean, default: false
    User.all.each do |user|
      status_is_pending = user.background_check_status == 'pending'
      user.update(inquiry_pending: status_is_pending)
    end
  end
end
