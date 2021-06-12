# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    after_action :track_user_location, only: :create

    def destroy
      @user = current_user
      super
    end

    def after_sign_in_path_for(resource)
      return edit_profile_path(resource) unless resource.role

      stored_location = stored_location_for(resource)
      return stored_location if stored_location
      return customer_dashboard_path if resource.agent?
      return co_borrower_root_path if resource.co_borrower? && (!resource.skip_onbording || resource.city.nil?)
      return co_borrower_dashboard_path if resource.co_borrower?

      admin_root_path if resource.admin?
    end

    def after_sign_out_path_for(_resource)
      if @user.agent?
        professionals_path(sign_out: true)
      else
        root_path(sign_out: true)
      end
    end

    protected

    def track_user_location
      MixpanelTracker.track_log_in(resource, request.remote_ip)
    end
  end
end
