# frozen_string_literal: true

module LookAround
  class MultipleVendorPropertiesFinderService
    include Sanitizers::PropertiesFinderParamsSanitizer
    AVAILABLE_VENDORS = %w[crmls claw beaor].freeze

    def initialize(params)
      @params = params
    end

    def execute
      properties_from_all_resources
    end

    private

    def properties_from_all_resources
      next_batch_link = ''
      total_results = ''
      unique_properties = AVAILABLE_VENDORS.each_with_object({}) do |vendor, memo|
        properties_response = get_properties_by_vendor(vendor)
        next_batch_link ||= properties_response[:next_batch_link]
        total_results ||= "+#{properties_response[:total_results]}"
        memo.merge!(properties_response[:properties])
      end
      properties = unique_properties.values
      { properties: properties, next_batch_link: next_batch_link, total_results: total_results }
    end

    def get_properties_by_vendor(vendor)
      search_params = @params.clone.append([:vendor, vendor])
      response = SimplyRets.request_properties(search_params)
      next_batch_link = sanitized_link(response.headers[:link])
      total_results = response.headers[:x_total_count]
      properties = JSON.parse(response.body)
      { properties: index_properties(properties), next_batch_link: next_batch_link, total_results: total_results }
    end

    def index_properties(properties)
      # use property full address as identifier
      properties.each_with_object({}) do |property, memo|
        memo[sanitized_address(property)] = property
      end
    end
  end
end
