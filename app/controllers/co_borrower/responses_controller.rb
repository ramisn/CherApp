# frozen_string_literal: true

module CoBorrower
  class ResponsesController < BaseController
    before_action :user_blocked?, :user_needs_verification?, only: %i[new]

    def new; end

    def create
      response = SaveUserResponsesService.call(current_user, response_params)
      if response.success?
        flash[:notice] = t('flashes.responses.create.notice')
        redirect_to co_borrower_root_path
      else
        flash[:alert] = t('flashes.responses.create.alert')
        render 'new'
      end
    end

    def destroy
      response = ResetPersonalityTestService.call(current_user)
      if response.success?
        flash[:notice] = t('flashes.responses.delete.notice')
        redirect_to new_co_borrower_response_path
      else
        flash[:alert] = t('flashes.responses.delete.alert')
        redirect_to co_borrower_dashboard_path
      end
    end

    private

    def response_params
      responses = params.require(:user).permit(:last_question_reponded,
                                               responses_attributes: %i[id
                                                                        response
                                                                        live_factor_id])

      responses.reject { |_k, v| v.blank? }
    end

    def user_blocked?
      return unless current_user.blocked?

      flash[:alert] = t('flashes.verifications.blocked_user', date: current_user.test_blocked_till)
      redirect_to co_borrower_dashboard_path
    end

    def user_needs_verification?
      return unless current_user.needs_verification

      flash[:alert] = t('flashes.verifications.needs_validation')
      redirect_to new_identification_path
    end
  end
end
