# frozen_string_literal: true

class FindSimilarPropertiesService
  def initialize(property, limit = 5)
    @property_price = property['listPrice']
    @property_city = property['address']['city']
    @property_bedrooms = property['property']['bedrooms']
    @limit = limit
  end

  def execute
    response = SimplyRets.request_properties(request_params)
    JSON.parse(response.body)
  end

  def request_params
    [
      [:cities, @property_city],
      [:minbeds, @property_bedrooms],
      [:maxbeds, @property_bedrooms],
      [:minprice, @property_price - 125_00],
      [:maxprice, @property_price + 125_000],
      [:limit, @limit]
    ]
  end
end
