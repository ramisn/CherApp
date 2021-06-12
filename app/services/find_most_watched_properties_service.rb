# frozen_string_literal: true

class FindMostWatchedPropertiesService
  def initialize(areas, number, date = 1.week.ago)
    @areas = areas
    @limit = number
    @date = date
  end

  def most_watched_properties
    return [] unless @limit.positive?
    return [] if properties_ids.empty?

    properties = SimplyRets.find_properties_by_ids(properties_ids)
    properties.select { |p| valid_property?(p) }.first(@limit)
  end

  def properties_ids
    @properties_ids ||= SeenProperty.by_city(@areas)
                                    .last_seen(@date)
                                    .grouped_by_property
                                    .ordered_by_seen
                                    .pluck(:property_id)
  end

  def valid_property?(property)
    property.key?('listDate')
  end
end
