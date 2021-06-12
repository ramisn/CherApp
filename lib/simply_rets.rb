# frozen_string_literal: true

class SimplyRets
  require 'rest-client'
  SIMPLYRETS_URL = "https://#{ENV['SIMPLYRETS_USER']}:#{ENV['SIMPLYRETS_PASSWORD']}@api.simplyrets.com"
  AVAILABLE_VENDORS = %w[claw crmls beaor].freeze

  def self.request_properties(params)
    search_params = params.clone
    is_vendor_given = search_params.flatten(1).include?(:vendor)
    response = if is_vendor_given
                 properties_api_call(search_params)
               else
                 # since some vendors does not include data from specific city/address
                 # we need to iterate over all the availables
                 first_find_over_vendors(search_params)
               end
    return '[]' if response.code != 200

    response
  rescue StandardError => _e
    empty_response
  end

  def self.request_open_houses(params)
    params << [:vendor, 'claw'] unless params.flatten(1).include?(:vendor)
    formated_params = RestClient::ParamsArray.new(params)
    response = RestClient.get(simply_rets_url('openhouses'), params: formated_params)
    return '[]' if response.code != 200

    response
  rescue StandardError => _e
    empty_response
  end

  def self.request_openhouse(params = {})
    response = request_open_houses(params)
    JSON.parse(response.to_s).first
  rescue StandardError => _e
    empty_response
  end

  def self.find_properties_by_ids(ids)
    builded_params = ids.map { |id| [:q, id] }
    properties = []
    AVAILABLE_VENDORS.each do |vendor|
      params = builded_params.dup
      params << [:vendor, vendor]
      response = request_properties(params)
      properties += JSON.parse(response.body)
    end
    properties
  end

  def self.find_property_by_id(id)
    params = sanitized_params(q: id,
                              type: %w[residential rental mobilehome condominium multifamily],
                              status: %w[Active Pending Closed ActiveUnderContract Hold Withdrawn Expired Delete Incomplete ComingSoon])
    response = request_properties(params.clone)
    property = JSON.parse(response.body).first
    return property unless property.blank?

    params << [:vendor, 'crmls']
    response = request_properties(params)
    JSON.parse(response.body).first
  end

  def self.sanitized_params(params)
    params.map do |key, value|
      if value.is_a?(Array)
        value.map { |v| [key, v] }
      else
        [[key, value]]
      end
    end.flatten(1)
  end

  def self.simply_rets_url(path)
    "#{SIMPLYRETS_URL}/#{path}"
  end

  def self.empty_response
    OpenStruct.new(body: '[]', headers: [])
  end

  def self.first_find_over_vendors(search_params)
    response = nil
    AVAILABLE_VENDORS.each do |vendor|
      params = search_params.dup
      params << [:vendor, vendor]
      response = properties_api_call(params)
      break if JSON.parse(response).any?
    end
    response
  end

  def self.properties_api_call(search_params)
    formated_params = RestClient::ParamsArray.new(search_params)
    RestClient.get(simply_rets_url('properties'), params: formated_params)
  end
end
