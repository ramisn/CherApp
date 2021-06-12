# frozen_string_literal: true

# Executed every night at 00:00 with the objective of updating the current prices of the properties
class SetPropertyPricesService
  def execute
    properties_ids = PropertyPrice.pluck(:property_id)
    SimplyRets.find_properties_by_ids(properties_ids).each { |mls_today_data| update_price(mls_today_data) }
  end

  private

  def update_price(mls_today_data)
    property_id = mls_today_data['listingId']
    price = mls_today_data['listPrice']

    property = PropertyPrice.find_by(property_id: property_id)

    property.update(price: price) if property.price != price
  end
end
