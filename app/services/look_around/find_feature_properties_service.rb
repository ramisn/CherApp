# frozen_string_literal: true

module LookAround
  class FindFeaturePropertiesService
    def initialize(user)
      @user = user
      @feature_properties_params = { minprice: 500_000,
                                     maxprice: 2_000_000,
                                     limit: 9,
                                     status: 'Active',
                                     search_in: user&.city || 'Santa Monica' }
    end

    def execute
      {
        properties: serialized_properties,
        flagged_properties_ids: flagged_properties_ids_by_user(feature_properties),
        can_save_search: false
      }
    end

    private

    def serialized_properties
      PropertiesSerializer.new(feature_properties).serialize
    end

    def feature_properties
      @feature_properties ||= PropertiesFinderService.new(@feature_properties_params, @user).execute[:properties]
    end

    def flagged_properties_ids_by_user(properties)
      FlaggedPropertiesIdsFinderService.new(properties, @user&.id).execute
    end
  end
end
