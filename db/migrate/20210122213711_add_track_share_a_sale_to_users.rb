# frozen_string_literal: true

class AddTrackShareASaleToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :track_share_a_sale, :boolean, default: nil
  end
end
