# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    protect_from_forgery prepend: true
    before_action :configure_permitted_parameters
    before_action :append_confirmation_param, only: :create
    after_action :update_user_extra_params, :track_user_registration, only: :create

    def new
      @referrer = User.find_by(referral_code: params[:referral_code])
      super
    end

    def create
      @referrer = User.find_by(referral_code: params[:referral_code])
      respond_to do |format|
        format.html { super }
        format.json do
          build_resource(sign_up_params)
          render json: { errors: resource.errors, valid: resource.valid? }, status: resource.valid? ? 200 : 401
        end
      end
    end

    def destroy
      resource.discard
      send_email_notifications
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      set_flash_message :notice, :destroyed
      yield resource if block_given?
      redirect_to root_path
    end

    protected

    def send_email_notifications
      UserAccountMailer.with(user: @user).delete_account.deliver_later
      Clique::DeleteSubscriptionService.new(current_user).execute if resource.agent?
    end

    def after_inactive_sign_up_path_for(_resource)
      new_user_session_path
    end

    def after_sign_up_path_for(resource)
      return edit_profile_path(resource) unless resource.role
      return customer_dashboard_path if resource.agent?
      return co_borrower_root_path if resource.co_borrower?

      admin_root_path if resource.admin?
    end

    def append_confirmation_param
      params[:user].merge!(confirmed_at: Time.now)
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[role professional_role accept_referral_agreement confirmed_at])
      devise_parameter_sanitizer.permit(:sign_in, keys: %i[first_name last_name])
      devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
      devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
    end

    def update_user_extra_params
      return unless resource.persisted?

      resource.update(search_intent: cookies[:search_intent], invited_by: @referrer)
      resource.create_activity(key: 'user.referred', recipient: resource.invited_by) if resource.invited_by
    end

    def track_user_registration
      return unless resource.persisted?

      mixpanel_key = cookies.to_h.keys.grep(/mp_.*_mixpanel/)&.first
      mixpanel_data = mixpanel_key.blank? ? nil : JSON.parse(cookies[mixpanel_key])
      mixpanel_data['$ip'] = request.remote_ip unless mixpanel_data.blank?

      resource.track_registration_event(mixpanel_data)
    end
  end
end
