# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      response = authenticate_user
      if response.success?
        track_user_registration(response.user)
        redirect_user(response.user, 'Facebook')
      else
        flash[:alert] = response.errors[:email].first if response.errors[:email].first
        redirect_to new_user_registration_path
      end
    end

    def google_oauth2
      response = authenticate_user
      if response.success?
        track_user_registration(response.user)
        redirect_user(response.user, 'Google')
      else
        flash[:alert] = response.errors[:email].first if response.errors[:email].first
        redirect_to new_user_registration_path
      end
    end

    def linkedin
      response = authenticate_user
      if response.success?
        track_user_registration(response.user)
        redirect_user(response.user, 'LinkedIn')
      else
        flash[:alert] = response.errors[:email].first if response.errors[:email].first
        redirect_to new_user_registration_path
      end
    end

    def failure
      redirect_to root_path
    end

    private

    def redirect_user(user, provider)
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider) if sign_in user

      return redirect_to edit_profile_path(user) unless user.role

      stored_location = stored_location_for(user)
      return redirect_to stored_location if stored_location

      if user.agent?
        redirect_to customer_dashboard_path
      else
        redirect_to user.skip_onbording ? co_borrower_dashboard_path : co_borrower_root_path
      end
    end

    def authenticate_user
      CreateUserFromOmniauthService.call(request.env['omniauth.auth'].except('extra'),
                                         request.env['omniauth.params'],
                                         cookies[:search_intent])
    end

    def track_user_registration(user)
      return unless Rails.env.production? || Rails.env.staging?

      mixpanel_key = cookies.to_h.keys.grep(/mp_.*_mixpanel/)&.first
      mixpanel_data = mixpanel_key.blank? ? nil : JSON.parse(cookies[mixpanel_key])
      mixpanel_data['$ip'] = request.remote_ip unless mixpanel_data.blank?

      user.track_registration_event(mixpanel_data)
    end
  end
end
