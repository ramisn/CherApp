# frozen_string_literal: true

class AddPublicationReferenceToComment < ActiveRecord::Migration[6.0]
  def change
    add_reference :comments, :publication, index: true, foreign_key: { to_table: :publications }
  end
end
