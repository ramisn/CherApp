# frozen_string_literal: true

module Users
  class InvitationsController < Devise::InvitationsController
    after_action :registry_sign_up, only: %i[update]
    before_action :configure_permitted_parameters
    respond_to :html, :json

    protected

    def after_invite_path_for(_resource)
      request.referrer
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:accept_invitation, keys: %i[first_name last_name])
    end

    def invitation_params
      params.require(:user)
            .permit(:body, :recipient_name, :recipient_email, :user_name)
            .merge(email: params.dig(:user, :recipient_email))
    end

    def registry_sign_up
      return if resource.invitation_accepted_at.blank?

      mixpanel_key = cookies.to_h.keys.grep(/mp_.*_mixpanel/)&.first
      mixpanel_data = mixpanel_key.blank? ? nil : JSON.parse(cookies[mixpanel_key])
      mixpanel_data['$ip'] = request.remote_ip unless mixpanel_data.blank?

      resource.track_registration_event(mixpanel_data)
    end
  end
end
