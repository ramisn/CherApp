# frozen_string_literal: true

module Users
  class SimplerRegistrationsController < ApplicationController
    def create
      @new_user = User.new(user_params)
      if @new_user.save
        setup_user_registration
        flash[:notice] = t('devise.registrations.signed_up')
        return redirect_to customer_dashboard_path if @new_user.agent?

        redirect_to co_borrower_root_path if @new_user.co_borrower?
      else
        initialize_index
        flash.now[:alert] = t('devise.registrations.error')
        redirect_to new_user_session_path
        # render 'landing_page/show'
      end
    end

    private

    def initialize_index
      @posts = GhostBlog.last_3_posts
      @suggested_properties = LookAround::FindFeaturePropertiesService.new(current_user).execute[:properties].first(4)
    end

    def user_params
      params.require(:user)
            .permit(:email, :role)
            .merge(confirmed_at: Time.now)
    end

    def setup_user_registration
      @new_user.send_confirmation_instructions
      sign_in @new_user

      mixpanel_key = cookies.to_h.keys.grep(/mp_.*_mixpanel/)&.first
      mixpanel_data = mixpanel_key.blank? ? nil : JSON.parse(cookies[mixpanel_key])
      mixpanel_data['$ip'] = request.remote_ip unless mixpanel_data.blank?

      @new_user.track_registration_event(mixpanel_data)
    end
  end
end
