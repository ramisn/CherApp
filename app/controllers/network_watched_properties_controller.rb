# frozen_string_literal: true

class NetworkWatchedPropertiesController < AuthenticationsController
  def index
    properties = current_user.friends.inject([]) do |memo, user|
      memo + user.flagged_properties_data
    end
    render json: properties
  end
end
