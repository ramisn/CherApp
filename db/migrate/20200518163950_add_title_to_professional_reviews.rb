# frozen_string_literal: true

class AddTitleToProfessionalReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :professional_reviews, :title, :string
  end
end
