# frozen_string_literal: true

module LookAround
  class PropertiesContainerLocalsService
    def initialize(user, search_params)
      @user = user
      @saved_search_params = sanitized_search_params(search_params)
      @search_params = search_params.merge(limit: 10).to_h
    end

    def execute
      properties_response = PropertiesFinderService.new(@search_params, @user, only_main_resource: true).execute
      {
        saved_search: saved_search,
        flagged_properties_ids: flagged_properties_ids_by_user(properties_response[:properties]),
        title: I18n.t('generic.search_result'),
        can_save_search: true,
        **properties_response
      }
    end

    private

    def saved_search
      return nil unless @user

      @user.property_searches
           .with_statuses(@search_params[:status])
           .with_types(@search_params[:type])
           .find_by(@saved_search_params)
    end

    def flagged_properties_ids_by_user(properties)
      FlaggedPropertiesIdsFinderService.new(properties, @user&.id).execute
    end

    def sanitized_search_params(search_params)
      search_params.except(:lastId, :amount, :home_type,
                           :type, :status, :startdate, :cities,
                           :start_hour, :start_minute, :limit)
    end
  end
end
