# frozen_string_literal: true

class WalkScore
  def self.get_score(address, lat, lon)
    response = RestClient.get('https://api.walkscore.com/score',
                              params: {
                                address: address,
                                lat: lat,
                                lon: lon,
                                transit: 1,
                                bike: 1,
                                format: 'json',
                                wsapikey: ENV['WALKSCORE_API_KEY']
                              })
    return nil if response.code != 200

    JSON.parse(response.body)
  rescue StandardError => _e
    nil
  end
end
