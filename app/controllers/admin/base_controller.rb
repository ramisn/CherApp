# frozen_string_literal: true

module Admin
  class BaseController < AuthenticationsController
    protect_from_forgery with: :null_session
    before_action :verify_user_role!

    private

    def verify_user_role!
      return if current_user.admin?

      flash[:alert] = t('flashes.errors.access')
      redirect_to root_path
    end
  end
end
