# frozen_string_literal: true

class AddSubscriberActions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscribers, :is_subscribed, :boolean, default: true, null: false
    add_column :subscribers, :marked_as_spam, :boolean, default: false, null: false
    add_column :subscribers, :bounced, :boolean, default: false, null: false
  end
end
