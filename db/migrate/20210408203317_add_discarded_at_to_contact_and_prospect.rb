# frozen_string_literal: true

class AddDiscardedAtToContactAndProspect < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :discarded_at, :datetime
    add_column :prospects, :discarded_at, :datetime
  end
end
