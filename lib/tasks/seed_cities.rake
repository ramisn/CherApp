# frozen_string_literal: true

namespace :seed do
  task cities: :environment do
    PublicActivity.enabled = false
    properties_ids = (SeenProperty.pluck(:property_id) | FlaggedProperty.pluck(:property_id)).uniq

    SimplyRets.find_properties_by_ids(properties_ids).each do |property|
      city = property.dig('address', 'city')
      price = property.dig('listPrice')
      next unless city

      FlaggedProperty.where(property_id: property['listingId']).update_all(price_on_flag: price, city: city)
      SeenProperty.where(property_id: property['listingId']).update_all(city: city)
    end
  end
end
