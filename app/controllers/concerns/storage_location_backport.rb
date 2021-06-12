# frozen_string_literal: true

require 'active_support/concern'

module StorageLocationBackport
  extend ActiveSupport::Concern

  included do
    def storable_location?
      current_user.present? && request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
    end

    def store_user_location!
      store_location_for(:user, request.fullpath)
    end
  end
end
