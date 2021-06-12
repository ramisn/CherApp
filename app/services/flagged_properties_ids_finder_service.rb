# frozen_string_literal: true

class FlaggedPropertiesIdsFinderService
  def initialize(properties, user_id)
    @properties = properties
    @user_id = user_id
  end

  def execute
    return [] unless @user_id

    properties_ids = @properties.map { |property| property['listingId'] }
    FlaggedProperty.where(user_id: @user_id,
                          property_id: properties_ids)
                   .pluck(:property_id)
  end
end
