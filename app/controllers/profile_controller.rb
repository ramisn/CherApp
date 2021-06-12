# frozen_string_literal: true

class ProfileController < AuthenticationsController
  before_action :clean_budgets, only: :update

  def edit
    @user_serialized = UsersSerializer.new(current_user, scope: current_user).as_json
  end

  # rubocop:disable Metrics/AbcSize
  def update
    respond_to do |format|
      if current_user.update(user_params)
        format.html do
          notify_for_profile_completed if a_new_user?
          ProfessionalVerificationMailer.send_request(current_user.email).deliver_later unless current_user.number_license.blank?
          MixpanelTracker.update_user(current_user, user_params.to_h)
          redirect_to user_path, notice: t('flashes.profile.update.success')
        end
      else
        format.html { render 'edit', alert: t('flashes.profile.update.error') }
      end
      format.json { render json: UsersSerializer.new(current_user, scope: current_user).to_json }
    end
  rescue ArgumentError
    render 'edit', alert: t('flashes.profile.update.error')
  end
  # rubocop:enable Metrics/AbcSize

  private

  def a_new_user?
    @a_new_user ||= current_user.saved_change_to_role?
  end

  def agent_attributes
    %i[accept_referral_agreement number_license professional_role]
  end

  def notify_for_profile_completed
    WelcomeUserNotifierService.new(current_user).execute
    current_user.update_contact
  end

  def user_params
    user_role = current_user.role || params[:user][:role]
    params.require(:user)
          .permit(:first_name, :last_name, :image_stored, :role,
                  :search_intent, :accept_privacy_policy, :email,
                  :accept_terms_and_conditions, :phone_number,
                  :accept_referral_agreement, :sell_my_info,
                  :description, :company_name, :status, :skip_onbording,
                  :address1, :address2, :city, :state, :zipcode,
                  :number_license, :professional_role, :co_borrowers,
                  :date_of_birth, :gender, :property_type, :budget_from,
                  :budget_to, specialties: [], areas: [])
          .reject do |attr, _value|
            user_role.to_sym != :agent && agent_attributes.include?(attr.to_sym)
          end
  end

  def user_path
    if current_user.agent?
      customer_dashboard_path
    elsif params.dig('user', 'role')
      co_borrower_root_path
    else
      co_borrower_dashboard_path
    end
  end

  def clean_budgets
    params[:user][:budget_from] = nil if params[:user][:budget_from].blank?
    params[:user][:budget_to] = nil if params[:user][:budget_to].blank?
  end
end
