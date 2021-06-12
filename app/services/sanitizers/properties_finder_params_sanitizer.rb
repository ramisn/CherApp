# frozen_string_literal: true

module Sanitizers
  module PropertiesFinderParamsSanitizer
    STREET_REGEX = /\d+ .+/.freeze

    def append_flagged_properties(params, user)
      return params unless params[:status].present? && params[:status].include?('Flagged')

      flagged_properties_ids = user ? user.flagged_properties.pluck(:property_id) : []
      if params[:q].present? && flagged_properties_ids.any?
        params[:q] = params[:q] & flagged_properties_ids
      elsif params[:q].present?
        params[:q] = ['null']
      else
        params.merge!(q: flagged_properties_ids)
      end
    end

    def append_fractional_properties(params)
      return params unless params[:type].present? && params[:type].include?('fractional')

      registered_houses = House.all.pluck(:mlsid)
      params.merge(q: registered_houses)
    end

    def build_params_by_search_type(params, user)
      searching_in = params[:search_in] || ''
      searching_in = sanitized_search_in(searching_in)

      params[:points] = sanitize_points(params[:points]) if params[:points].present?

      # Downtown Los Angeles is not a city so we need to seach by q
      if searching_in =~ STREET_REGEX || searching_in.downcase.include?('downtown')
        params.merge!(q: searching_in)
      else
        params.merge!(cities: sanitized_city_search(searching_in))
        params.merge!(search_in: sanitized_city_search(searching_in))
        params = append_fractional_properties(params)
        append_flagged_properties(params, user)
      end
    end

    def sanitized_address(property)
      address = "#{property.dig('address', 'full')}, #{property.dig('address', 'city')}"
      # Address from claw uses abreviations while crmls dont
      address.gsub(/ave[, ]/i, 'Avenue,')
             .gsub(/blv/i, 'Boulevard')
             .gsub(/boulevardd/i, 'Boulevard')
             .gsub(/dr,/i, 'Drive,')
             .gsub(/pl,/i, 'Place,')
             .gsub(/st,/i, 'Street,')
             .titleize
    end

    def sanitized_search_in(searching_in)
      searching_in = I18n.transliterate(searching_in).gsub(/, .+/, '')
      # some people uses ave, and SimplyRETS doesnt know what it means
      searching_in.gsub(/ave$/i, 'Avenue')
    end

    def sanitized_city_search(searching_in)
      searching_in.sub(/, ..(, USA)?/, '')
    end

    def sanitize_datetime(search_params)
      date = Date.strptime(search_params[:startdate], '%m/%d/%Y')
      start_hour = search_params[:start_hour].to_i
      start_minute = search_params[:start_minute].to_i
      DateTime.new(date.year, date.month, date.day, start_hour, start_minute)
    end

    def sanitized_link(link)
      return '' unless link

      # SimplyRets returns link between '< >'
      sanitized_link = link[/<(.*?)>; rel="next"/m, 1]
      sanitized_link || ''
    end

    def sanitize_points(points)
      return '[]' unless points.present?

      JSON.parse(points)
    end
  end
end
