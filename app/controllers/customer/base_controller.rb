# frozen_string_literal: true

module Customer
  class BaseController < AuthenticationsController
    before_action :verify_user_role!
    before_action :verify_terms_and_privacy
    before_action :verify_referral_agreement

    private

    def verify_user_role!
      return if current_user.agent?

      flash[:alert] = t('flashes.errors.access')
      return redirect_to edit_profile_path(current_user) if current_user.role.blank?

      redirect_to root_path
    end

    def verify_terms_and_privacy
      return if current_user.accept_terms_and_conditions && current_user.accept_privacy_policy

      redirect_to root_path, flash: { alert: t('flashes.errors.access') }
    end

    def verify_referral_agreement
      return unless current_user.estate_agent? && !current_user.accept_referral_agreement

      redirect_to edit_profile_path(current_user), flash: { alert: t('flashes.errors.referral_agreement') }
    end
  end
end
