# frozen_string_literal: true

module LookAround
  class PropertiesJsonResponseService
    def initialize(user, search_params)
      @user = user
      @search_params = search_params.to_h
    end

    def execute
      {
        properties: searched_properties,
        flagged_properties_ids: flagged_properties_ids_by_user(searched_properties),
        notice: response_message
      }
    end

    private

    def flagged_properties_ids_by_user(properties)
      @flagged_properties_ids_by_user ||= FlaggedPropertiesIdsFinderService.new(properties, @user&.id).execute
    end

    def searched_properties
      @searched_properties ||= begin
        properties = PropertiesFinderService.new(@search_params, @user).execute[:properties]
        PropertiesSerializer.new(properties).serialize
      end
    end

    def response_message
      return '' if searched_properties.any?

      I18n.t('look_around.search.available_only_in')
    end
  end
end
