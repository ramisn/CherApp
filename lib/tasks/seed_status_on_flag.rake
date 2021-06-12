# frozen_string_literal: true

namespace :seed do
  task status_on_flag: :environment do
    PublicActivity.enabled = false
    properties_ids = FlaggedProperty.pluck(:property_id).uniq

    SimplyRets.find_properties_by_ids(properties_ids).each do |property|
      status = property.dig('mls', 'status')
      next unless status

      FlaggedProperty.where(property_id: property['listingId']).update_all(status_on_flag: status)
    end
  end
end
