# frozen_string_literal: true

class MakeCommentPolymorphic < ActiveRecord::Migration[6.0]
  def change
    remove_reference :comments, :activity
    add_reference :comments, :post, polymorphic: true
  end
end
