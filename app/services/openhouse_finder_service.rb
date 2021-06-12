# frozen_string_literal: true

class OpenhouseFinderService
  def initialize(property_id)
    @property_id = property_id
  end

  def execute
    openhouse = Redis.current.get(search_key)
    return JSON.parse(openhouse) unless openhouse.blank?

    openhouse = SimplyRets.request_openhouse(listingId: @property_id)
    # Make it expire in 24 hours
    Redis.current.set(search_key, openhouse.to_json, ex: 60 * 60 * 24)
    openhouse
  end

  private

  def search_key
    @search_key ||= "openhouse - #{@property_id}"
  end
end
