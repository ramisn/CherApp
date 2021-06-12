# frozen_string_literal: true

class AddAcceptTermsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :accept_terms_and_conditions, :boolean, default: false
    add_column :users, :accept_privacy_policy, :boolean, default: false
    add_column :users, :accept_referral_agreement, :boolean, default: false
  end
end
