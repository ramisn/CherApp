# frozen_string_literal: true

class Places
  def self.number_of_places_by_type(place_type, location)
    search_key = "places near #{location} #{place_type}"
    number_of_places = Redis.current.get(search_key)

    return number_of_places unless number_of_places.blank?

    params = { type: place_type,
               radius: 1610,
               location: location,
               key: ENV['GOOGLE_PLACES_API'] }
    response = RestClient.get('https://maps.googleapis.com/maps/api/place/nearbysearch/json', params: params)
    return 0 if response.code != 200

    number_of_places = JSON.parse(response)['results'].size
    Redis.current.set(search_key, number_of_places)
    number_of_places
  end

  def self.find_places(params)
    params.merge!(radius: 1610, key: ENV['GOOGLE_PLACES_API'], rankby: 'prominence')
    response = RestClient.get('https://maps.googleapis.com/maps/api/place/nearbysearch/json', params: params)
    return nil if response.code != 200

    places = JSON.parse(response.body)['results']

    places.map do |place|
      { 'address' => place['vicinity'],
        'name' => place['name'],
        'place_id' => place['place_id'],
        'rating' => place['rating'],
        'photos' => place['photos'] }
    end
  rescue StandardError => _e
    nil
  end

  def self.find_places_with_rate(params)
    places = find_places(params)
    return nil unless places

    places.reject do |place|
      place['rating'].nil? || place['photos'].nil?
    end
  end
end
