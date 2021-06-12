# frozen_string_literal: true

require 'active_support/concern'

module FlaggedPropertiesConcern
  extend ActiveSupport::Concern

  private

  def user_flagged_property_ids(user_id)
    user = User.find(user_id)
    user.flagged_properties.pluck(:property_id).each_with_object([]) do |property_id, arr|
      arr << [:q, property_id]
    end
  end

  def fetch_properties(property_ids)
    response = SimplyRets.request_properties(property_ids)
    response.blank? ? [] : JSON.parse(response)
  end
end
