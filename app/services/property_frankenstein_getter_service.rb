# frozen_string_literal: true

class PropertyFrankensteinGetterService
  def initialize(property)
    property_city = property['address']['city']
    property_state = property['address']['state']
    @address1 = property['address']['full']
    @address2 = "#{property_city}, #{property_state}"
    @full_address = "#{@address1}, #{@address2}"
    @lat = property['geo']['lat']
    @lng = property['geo']['lng']
    @postal_code = property['address']['postalCode']
  end

  def execute
    {
      walkscore: walkscore,
      schools: places_schools,
      hospitals: places_hospitals,
      restaurants: places_restaurants,
      history: property_history,
      sales_trend: property_sales_trend,
      expanded_profile: expanded_profile,
      preforeclosure_details: preforeclosure_details
    }
  end

  private

  def walkscore
    find_or_fetch_information(@full_address, @lat, @lng, klass: 'WalkScore', method: :get_score)
  end

  def places_schools
    find_or_fetch_information({ type: 'school', location: "#{@lat}, #{@lng}" },
                              klass: 'Places',
                              method: :find_places)
  end

  def places_hospitals
    find_or_fetch_information({ type: 'hospital', location: "#{@lat}, #{@lng}" },
                              klass: 'Places',
                              method: :find_places)
  end

  def places_restaurants
    find_or_fetch_information({ type: 'restaurant', location: "#{@lat}, #{@lng}" },
                              klass: 'Places',
                              method: :find_places_with_rate)
  end

  def property_history
    find_or_fetch_information({ address1: @address1, address2: @address2 },
                              klass: 'Attom',
                              method: :property_history)
  end

  def property_sales_trend
    find_or_fetch_information(@postal_code,
                              klass: 'Attom',
                              method: :last_year_sales_trend)
  end

  def expanded_profile
    find_or_fetch_information({ address1: @address1, address2: @address2 },
                              klass: 'Attom',
                              method: :expanded_profile)
  end

  def preforeclosure_details
    find_or_fetch_information({ full_address: @full_address,
                                postal_code: @postal_code },
                              klass: 'Attom',
                              method: :preforeclosure_details)
  end

  def find_or_fetch_information(*params, klass:, method:)
    key = "#{klass} - #{method} - #{params}"
    data = Redis.current.get(key)
    if data.blank?
      data = klass.constantize.send(method, *params)
      # Make it expire in 24 hours
      Redis.current.set(key, data.to_json, ex: 60 * 60 * 24) unless data.blank?
      data
    else
      JSON.parse(data)
    end
  end
end
