# frozen_string_literal: true

require_relative './sanitizers/properties_finder_params_sanitizer'

class PropertiesFinderService
  include Sanitizers::PropertiesFinderParamsSanitizer

  def initialize(search_params, user = nil, only_main_resource: false)
    @search_params = build_params_by_search_type(search_params, user)
    @only_main_resource = only_main_resource
  end

  def execute
    if @search_params[:startdate].blank?
      search_properties
    else
      search_open_houses
    end
  end

  private

  def sanitized_params
    @search_params.map do |key, value|
      if value.is_a?(Array)
        value.map { |v| [key, v] }
      elsif key != 'city' && value.present?
        [[key, value]]
      else
        []
      end
    end.flatten(1)
  end

  def search_key
    @search_key ||= @search_params.to_s
  end

  def search_properties
    properties_data = Redis.current.get(search_key)
    if properties_data.blank?
      fetch_from_simplyrets
    else
      parsed_data = JSON.parse(properties_data)
      properties = PropertiesLocalInformationAppenderService.new(parsed_data['properties']).execute
      { properties: properties, next_batch_link: parsed_data['next_batch_link'], total_results: parsed_data['total_results'] }
    end
  end

  def search_open_houses
    @search_params[:startdate] = sanitize_datetime(@search_params)
    @search_params[:points] = sanitize_points(@search_params[:points])
    response = SimplyRets.request_open_houses(sanitized_params)
    total_results = response.headers[:x_total_count]
    next_batch_link = sanitized_link(response.headers[:link])
    properties = JSON.parse(response.to_s).map! { |item| item['listing'] }
    properties = PropertiesLocalInformationAppenderService.new(properties).execute

    { properties: properties, next_batch_link: next_batch_link, total_results: total_results }
  end

  def fetch_from_simplyrets
    properties_data = if @only_main_resource
                        request_properties(sanitized_params)
                      else
                        LookAround::MultipleVendorPropertiesFinderService.new(sanitized_params).execute
                      end
    properties = properties_data[:properties]
    properties_with_local_information = PropertiesLocalInformationAppenderService.new(properties).execute
    # Make it expire in 24 hours
    Redis.current.set(search_key, properties_data.to_json, ex: 60 * 60 * 24) unless properties.blank?
    properties_data.merge(properties: properties_with_local_information)
  end

  def request_properties(params)
    response = SimplyRets.request_properties(params)
    next_batch_link = sanitized_link(response.headers[:link])
    total_results = response.headers[:x_total_count]
    properties = JSON.parse(response.body)
    { properties: properties, next_batch_link: next_batch_link, total_results: "+#{total_results}" }
  end
end
