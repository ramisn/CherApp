# frozen_string_literal: true

class CreatePersonalFactors < ActiveRecord::Migration[6.0]
  def change
    create_table :personal_factors do |t|
      t.boolean :pet
      t.integer :pet_type
      t.boolean :co_bo_with_pets
      t.integer :co_borrowers
      t.boolean :dependent_children
      t.boolean :romantic_relationship
      t.boolean :problem_with_relationship
      t.boolean :plaining_on_living_in_property
      t.integer :religion
      t.boolean :problem_with_religion
      t.integer :ethnicity
      t.boolean :problem_with_ethnicity
      t.integer :policially
      t.boolean :problem_with_policially
      t.integer :gender
      t.boolean :problem_with_gender
      t.integer :marital_status
      t.boolean :problem_with_marital_status
      t.boolean :smoker
      t.boolean :problem_with_smoker
      t.integer :age_range
      t.boolean :problem_with_age_range
      t.integer :how_long_owning_property
      t.belongs_to :user

      t.timestamps
    end
  end
end
