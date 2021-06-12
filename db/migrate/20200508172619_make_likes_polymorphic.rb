# frozen_string_literal: true

class MakeLikesPolymorphic < ActiveRecord::Migration[6.0]
  def change
    remove_reference :likes, :activity
    add_reference :likes, :post, polymorphic: true
  end
end
