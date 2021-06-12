# frozen_string_literal: true

class AddRecipientToPublication < ActiveRecord::Migration[6.0]
  def change
    add_reference :publications, :recipient, index: true, foreign_key: { to_table: :users }
  end
end
