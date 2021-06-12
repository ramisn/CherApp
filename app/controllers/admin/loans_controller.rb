# frozen_string_literal: true

require 'csv'

module Admin
  class LoansController < BaseController
    before_action :find_user
    before_action :find_loan, only: %i[edit update show]

    def index
      @requested_loans = if params[:filter]
                           @user.requested_loans.where(status: params[:filter].to_sym)
                         else
                           @user.requested_loans
                         end
    end

    def edit; end

    def update
      if @loan.update(loan_params)
        flash[:notice] = t('flashes.loans.update.notice')
        redirect_to admin_co_borrower_loans_path
        UsersMailer.notify_loan_completed(@loan.user).deliver_later if @loan.finished?
      else
        flash[:alert] = t('flashes.loans.update.alert')
        render 'edit'
      end
    end

    def show
      respond_to do |format|
        format.csv do
          headers['Content-Disposition'] = 'attachment; filename=contacts.csv'
          headers['Content-Type'] ||= 'text/csv'
        end
      end
    end

    private

    def find_user
      @user = User.find_by(slug: params[:co_borrower_id])
    end

    def find_loan
      @loan = @user.requested_loans.find(params[:id])
    end

    def loan_params
      params.require(:loan)
            .permit(:status, :unique_code, :property_street,
                    :property_city, :property_state,
                    :property_zipcode, :property_county,
                    :property_type, :property_occupied)
    end
  end
end
