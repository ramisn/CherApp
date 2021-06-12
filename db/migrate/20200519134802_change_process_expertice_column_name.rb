# frozen_string_literal: true

class ChangeProcessExperticeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :professional_reviews, :process_expertice, :process_expertise
  end
end
