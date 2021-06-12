# frozen_string_literal: true

module CoBorrower
  class BaseController < AuthenticationsController
    before_action :verify_user_role!, :verify_terms_and_privacy

    private

    def verify_user_role!
      return if current_user.co_borrower?

      flash[:alert] = t('flashes.errors.access')
      return redirect_to edit_profile_path(current_user) if current_user.role.blank?

      redirect_to root_path
    end

    def verify_terms_and_privacy
      return if current_user.accept_privacy_policy && current_user.accept_terms_and_conditions

      redirect_to root_path, flash: { alert: t('flashes.errors.access') }
    end
  end
end
