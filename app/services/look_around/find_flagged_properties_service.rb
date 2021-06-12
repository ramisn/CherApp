# frozen_string_literal: true

module LookAround
  class FindFlaggedPropertiesService
    def initialize(user)
      @user = user
    end

    def execute
      {
        properties: serialized_properties,
        flagged_properties_ids: flagged_properties_ids_by_user(flagged_properties),
        can_save_search: false
      }
    end

    private

    def serialized_properties
      PropertiesSerializer.new(flagged_properties).serialize
    end

    def flagged_properties
      @flagged_properties ||= PropertiesLocalInformationAppenderService.new(@user.flagged_properties_data).execute
    end

    def flagged_properties_ids_by_user(properties)
      FlaggedPropertiesIdsFinderService.new(properties, @user&.id).execute
    end
  end
end
