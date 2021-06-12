# frozen_string_literal: true

class TopPropertiesService
  DEFAULT_CITY = 'Los Angeles'
  DEFAULT_MIN_PRICE = 100_000

  def initialize(user, limit = 5, suggested = false, watched_properties_finder = FindMostWatchedPropertiesService)
    @user = user
    @limit = limit
    @suggested = suggested
    @watched_properties_finder = watched_properties_finder
  end

  def execute
    price_drops = properties_with_changed_price
    new_properties = new_active_properties(@limit - price_drops.size)
    popular_properties = most_seen_properties(@limit - price_drops.size - new_properties.size)

    { price_drops: price_drops,
      new_properties: new_properties,
      popular_properties: popular_properties }
  end

  def properties_with_changed_price
    return [] if @suggested

    properties = []

    @user.flagged_properties.order(id: :desc).each do |property|
      break if properties.size == 5

      properties << property.mls_data if property.price_difference.positive?
    end

    properties
  end

  def new_active_properties(limit)
    return [] unless limit.positive?

    params = { limit: limit, search_in: @user.base_city || DEFAULT_CITY, status: 'Active', sort: '-listdate',
               type: %w[residential mobilehome condominium multifamily commercial land farm], minprice: DEFAULT_MIN_PRICE }

    PropertiesFinderService.new(params).execute[:properties].select { |p| valid_property?(p) }
  end

  def most_seen_properties(limit)
    @watched_properties_finder.new(@user.base_city, limit).most_watched_properties
  end

  private

  def valid_property?(property)
    property.key?('listDate') && !@user.flagged?(property['listingId'])
  end
end
