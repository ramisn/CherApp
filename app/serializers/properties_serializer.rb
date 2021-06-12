# frozen_string_literal: true

class PropertiesSerializer
  def initialize(properties)
    @properties = properties
  end

  # rubocop:disable Metrics/AbcSize
  def serialize
    @properties.map! do |property|
      property_geo = property['geo']

      { 'address' => property_address(property),
        'geo' => property_geo ? { 'lat': property_geo['lat'], 'lng': property_geo['lng'] } : nil,
        'listDate' => property['listDate'],
        'listingId' => property['listingId'],
        'type' => property['property']['type'],
        'photos' => property['photos'].blank? ? nil : property['photos'],
        'property' => { 'type' => property['property']['type'], 'bedrooms' => property['property']['bedrooms'], 'bathrooms' => property['property']['bathrooms'] },
        'listPrice' => property['listPrice'],
        'users_who_flagged' => property['users_who_flagged'] }
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def property_address(property)
    property_address = property['address']
    property_geo = property['geo']

    { 'city': property_address['city'],
      'state': property_address['state'],
      'postalCode': property_address['postalCode'],
      'county': property_geo['county'],
      'full' => property_address['full'] }
  end
end
