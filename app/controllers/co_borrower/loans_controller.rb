# frozen_string_literal: true

module CoBorrower
  class LoansController < BaseController
    before_action :verify_user_profile, :find_flagged_properties

    def new
      if user_can_request_loan?
        @loan = Loan.new
      else
        flash[:alert] = 'You already have a loan request in progress'
        redirect_to co_borrower_dashboard_path
      end
    end

    def create
      if user_can_request_loan?
        @loan = current_user.requested_loans.new(loan_params)
        if @loan.save
          flash[:notice] = t('flashes.loans.create.notice')
          redirect_to co_borrower_loan_path(@loan, process_finished: true)
        else
          flash[:alert] = t('flashes.loans.create.alert')
          render 'new'
        end
      else
        flash[:alert] = 'You already have a loan request in progress'
        redirect_to co_borrower_dashboard_path
      end
    end

    def show
      @loan = current_user.requested_loans
                          .includes(:participants)
                          .find(params[:id])
    end

    private

    def find_flagged_properties
      @flagged_properties = current_user.flagged_properties_data
    end

    def loan_params
      params.require(:loan)
            .permit(:property_id, :property_street, :property_state,
                    :property_type, :property_zipcode, :property_city,
                    :property_county, :first_home, :live_there,
                    participants_attributes: %i[user_id])
    end

    def verify_user_profile
      if current_user.full_name.blank?
        flash[:alert] = 'You need to first set your first name, last name and a profile picture'
        redirect_to edit_profile_path(current_user)
      elsif current_user.image.blank? && !current_user.image_stored.attached?
        flash[:alert] = 'You need to first set your profile picture'
        redirect_to co_borrower_dashboard_path
      end
    end

    def user_can_request_loan?
      current_user.active_loan_request.blank?
    end
  end
end
