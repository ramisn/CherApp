# frozen_string_literal: true

class CreateProfessionalReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :professional_reviews do |t|
      t.references :reviewer, null: false, index: true, foreign_key: { to_table: :users }
      t.references :reviewed, null: false, index: true, foreign_key: { to_table: :users }
      t.text :comment
      t.integer :local_knowledge, null: false, default: 0
      t.integer :process_expertice, null: false, default: 0
      t.integer :responsiveness, null: false, default: 0
      t.integer :negotiation_skills, null: false, default: 0

      t.timestamps
    end
  end
end
