# frozen_string_literal: true

class PropertyFinderService
  def initialize(property_data)
    @property_identifier = property_data[:address] || property_data[:id]
    @property_identifier.gsub!(/ave$/i, 'Avenue')
  end

  def execute
    property = find_property
    return nil if property.blank?

    append_local_information(property)
  end

  private

  def find_property
    property = Redis.current.get(search_key)
    return JSON.parse(property) unless property.blank?

    property = SimplyRets.find_property_by_id(@property_identifier)
    return nil if property.blank?

    # MLF for multifamily properties. SimplyRets does not give us beds/baths
    property = append_missing_information(property) if property['property']['type'] == 'MLF'
    # Make it expire in 24 hours
    Redis.current.set(search_key, property.to_json, ex: 60 * 60 * 24)
    property
  end

  def search_key
    @search_key ||= "property - #{@property_identifier}"
  end

  def append_local_information(property)
    house = House.find_by(mlsid: property['listingId'])
    users_who_flagged = FlaggedProperty.where(property_id: property['listingId'])
                                       .includes(:user)
                                       .map(&:user)
    property.merge('users_who_flagged' => users_who_flagged || [],
                   'selling_percentage' => house&.selling_percentage,
                   'owner_name' => house&.owner&.full_name,
                   'owner_email' => house&.email_contact,
                   'owner_phone' => house&.phone_contact)
  end

  def append_missing_information(property)
    property_extra_data = get_attom_data(property['address'])
    baths = property_extra_data.dig('building', 'rooms', 'bathstotal').to_i
    beds = property_extra_data.dig('building', 'rooms', 'beds').to_i
    property['property'].merge!('bathrooms' => baths, 'bedrooms' => beds)
    property
  end

  def get_attom_data(property_address)
    property_addres1 = property_address['full']
    property_addres2 = "#{property_address['city']}, #{property_address['state']}"
    Attom.get_property(address1: property_addres1, address2: property_addres2)
  end
end
