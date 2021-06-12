# frozen_string_literal: true

class PropertiesLocalInformationAppenderService
  def initialize(properties)
    @properties = properties
  end

  def execute
    return [] if @properties.blank?

    @properties = JSON.parse(@properties) unless @properties.is_a?(Array)
    users_who_flagged_by_property = group_flagged_properties

    @properties.map do |property|
      property_id = property['listingId']
      property.merge('users_who_flagged' => users_who_flagged_by_property[property_id] || [],
                     'selling_percentage' => property_selling_percentage(property_id))
    end
  end

  private

  def group_flagged_properties
    grouped_flagged_properties = FlaggedProperty.where(property_id: properties_ids)
                                                .includes(:user)
                                                .group_by(&:property_id)
    sort_users_by_properties(grouped_flagged_properties)
  end

  def properties_ids
    @properties_ids ||= @properties.map { |property| property['listingId'] }
  end

  def properties_registered_on_cher
    @properties_registered_on_cher ||= House.where(mlsid: properties_ids, status: :approved)
  end

  def property_selling_percentage(property_id)
    properties_registered_on_cher.find { |house| house.mlsid == property_id }&.selling_percentage
  end

  def sort_users_by_properties(flagged_properties)
    flagged_properties.map do |property_id, collection|
      { property_id => collection.map(&:user) }
    end.reduce({}, :merge)
  end
end
