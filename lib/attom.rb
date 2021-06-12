# frozen_string_literal: true

class Attom
  def self.get_property(params)
    response = RestClient.get('https://api.gateway.attomdata.com/propertyapi/v1.0.0/property/detail',
                              Accept: 'application/json',
                              APIKey: ENV['ATTOM_API_KEY'],
                              params: params)
    return {} if response.code != 200

    response_data = JSON.parse(response.body)
    response_data['property'].first
  rescue StandardError => _e
    {}
  end

  def self.property_history(params)
    response = RestClient.get('https://api.gateway.attomdata.com/propertyapi/v1.0.0/saleshistory/detail',
                              Accept: 'application/json',
                              APIKey: ENV['ATTOM_API_KEY'],
                              params: params)
    return nil if response.code != 200

    property_data = JSON.parse(response.body)['property'].first
    return nil unless property_data

    property_data['salehistory']
  rescue StandardError => _e
    nil
  end

  def self.last_year_sales_trend(zipcode)
    # For some reason Attom needs ZI before postal code
    zipcode = "ZI#{zipcode}"
    params = { geoid: zipcode, interval: 'yearly', startyear: Date.today.year - 1, endyear: Date.today.year }
    response = RestClient.get('https://api.gateway.attomdata.com/propertyapi/v1.0.0/salestrend/snapshot',
                              Accept: 'application/json',
                              APIKey: ENV['ATTOM_API_KEY'],
                              params: params)
    return nil if response.code != 200

    sales_trend = JSON.parse(response.body)['salestrends']
    return nil if sales_trend.blank?

    sales_trend.last['SalesTrend']
  rescue StandardError => _e
    nil
  end

  def self.expanded_profile(params)
    response = RestClient.get('https://api.gateway.attomdata.com/propertyapi/v1.0.0/property/expandedprofile',
                              Accept: 'application/json',
                              APIKey: ENV['ATTOM_API_KEY'],
                              params: params)
    return nil if response.code != 200

    property_data = JSON.parse(response.body)['property'].first

    property_data
  rescue StandardError => _e
    nil
  end

  def self.preforeclosure_details(params)
    params[:full_address] = params[:full_address].gsub(/#/, '')
    params = { combinedAddress: "#{params[:full_address]}, #{params[:postal_code]}" }
    response = RestClient::Request.execute(method: :get, url: 'https://api.attomdata.com/property/v3/preforeclosuredetails',
                                           headers: { 'Ocp-Apim-Subscription-Key' => ENV['ATTOM_OCP_KEY'],
                                                      accept: :json,
                                                      params: params })

    return nil if response.code != 200

    property_data = JSON.parse(response.body)

    return nil unless property_data

    property_data['PreforeclosureDetails']
  rescue StandardError => _e
    nil
  end
end
