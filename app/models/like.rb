# frozen_string_literal: true

# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_type  :string
#  post_id    :bigint
#
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post, polymorphic: true

  after_create :track_activity

  def track_activity
    return unless Rails.env.production? || Rails.env.staging?

    MixpanelTracker.track_event(user.email, 'Liked a publication', {})
  end
end
