# frozen_string_literal: true

class MakeTermsAndConditionsTtrueByDefault < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :accept_terms_and_conditions, :boolean, default: true, null: false
    change_column :users, :accept_privacy_policy, :boolean, default: true, null: false
  end
end
