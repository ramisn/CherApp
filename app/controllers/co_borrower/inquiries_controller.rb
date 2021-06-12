# frozen_string_literal: true

module CoBorrower
  class InquiriesController < BaseController
    def new
      return if user_can_request_inquiry?

      flash[:alert] = background_status_error
      redirect_to co_borrower_dashboard_path
    end

    def create
      if user_can_request_inquiry?
        InquiryRequestedMailer.notify_admin(inquiry_params).deliver_later
        current_user.update!(inquiry_params)
        flash[:notice] = t('flashes.inquiries.update.notice')
      else
        flash[:alert] = background_status_error
      end
      redirect_to co_borrower_dashboard_path
    end

    private

    def inquiry_params
      date_of_birth = Date.strptime(params.dig(:inquiry, :date_of_birth), '%m/%d/%Y')
      params.require(:inquiry)
            .permit(:middle_name, :first_name, :last_name)
            .merge(background_check_status: :pending,
                   date_of_birth: date_of_birth)
    end

    def user_can_request_inquiry?
      current_user.background_check_status == 'no_requested'
    end

    def background_status_error
      return t('flashes.inquiries.update.already_requested') if current_user.background_check_status == 'pending'

      return t('flashes.inquiries.update.already_approved') if current_user.background_check_status == 'approved'

      return t('flashes.inquiries.update.rejected') if current_user.background_check_status == 'rejected'
    end
  end
end
