# frozen_string_literal: true

class FlaggedNotificationTrackerJob < ApplicationJob
  queue_as :default

  def perform(flagged_property)
    return unless Rails.env.production? || Rails.env.staging?

    property_data = SimplyRets.find_property_by_id(flagged_property.property_id)
    event_params = { 'Property price': property_data['listPrice'],
                     'Property ID': flagged_property.property_id,
                     'Property city': property_data.dig('address', 'city'),
                     'Property address': property_data.dig('address', 'full'),
                     'Property state': property_data.dig('address', 'state') }
    MixpanelTracker.track_event(flagged_property.user.email, 'Flagged property', event_params)
  end
end
