# frozen_string_literal: true

# == Schema Information
#
# Table name: flagged_properties
#
#  id             :bigint           not null, primary key
#  property_id    :string           not null
#  user_id        :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  city           :string           default(""), not null
#  price_on_flag  :bigint           default(0), not null

class FlaggedProperty < ApplicationRecord
  include PublicActivity::Model
  tracked owner: proc { |controller, _model| controller&.current_user },
          params: { property_id: proc { |_controller, model| model.property_id } }

  belongs_to :user
  scope :by_location, ->(property_id, city) { where('property_id = ? OR city = ?', property_id, city) }
  scope :unique_users_id, -> { distinct(:user_id).pluck(:user_id) }
  scope :people_who_also_flagged, lambda { |property_id, city, user_id, users_limit|
                                    User.public_users(user_id)
                                        .with_name
                                        .where(id: by_location(property_id.to_s, city)
                                                   .where.not(user_id: user_id)
                                                   .limit(users_limit)
                                                   .unique_users_id)
                                        .where.not(first_name: nil)
                                  }

  validates_presence_of :property_id

  after_create :create_notifications, :track_flagged
  after_destroy :remove_notifications

  def self.find_flagged_by_user(property_id, user_id)
    find_by(property_id: property_id, user_id: user_id)
  end

  def create_notifications
    CreateFlaggedPropertyNotificationJob.perform_later(self)
  end

  def track_flagged
    FlaggedNotificationTrackerJob.perform_later(self)
  end

  def remove_notifications
    Notification.delete_flagged_property(self)
  end

  def mls_data
    @mls_data ||= PropertyFinderService.new(id: property_id).execute
  end

  def active_and_has_list_date?
    status = mls_data&.dig('mls', 'status')
    list_date = mls_data&.dig('listDate')

    status == 'Active' && list_date
  end

  def price_difference
    return 0 unless active_and_has_list_date?

    difference = current_price - price_on_flag
    update_price_on_flag(price_on_flag) if price_on_flag.zero?

    difference
  end

  def current_status
    mls_data&.dig('mls', 'status')
  end

  def current_price
    mls_data&.dig('listPrice')
  end

  def update_price_on_flag(price)
    update(price_on_flag: price)
  end

  def status_changed?
    current_status != status_on_flag
  end
end
