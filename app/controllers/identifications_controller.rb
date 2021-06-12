# frozen_string_literal: true

class IdentificationsController < AuthenticationsController
  before_action :user_identity_is_validated?
  before_action :validate_user_profile, only: :create

  def new; end

  def create
    if current_user.update(verification_type: params.dig(:data, :result, :type), needs_verification: false)
      flash[:notice] = t('flashes.verifications.notice')
    else
      flash[:alert] = t('flashes.verifications.alert')
    end
    redirect_user
  end

  private

  def redirect_user
    if current_user.agent?
      redirect_to customer_dashboard_path
    else
      redirect_to co_borrower_dashboard_path
    end
  end

  def user_identity_is_validated?
    return unless current_user.validated?

    flash[:alert] = t('flashes.verifications.already_validated')
    redirect_user
  end

  def validate_user_profile
    errors = params.dig(:data, :errors)
    return if errors.blank?

    flash[:alert] = errors.map { |error| error[:message] }.join(', ')
    redirect_to new_identification_path
  end
end
