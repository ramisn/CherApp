# frozen_string_literal: true

module Admin
  class InquiriesController < BaseController
    before_action :initialize_user, only: %i[edit update]
    before_action :valid_inquiry_status?, only: %i[update]

    def index
      @users = User.where(background_check_status: :pending)
    end

    def edit; end

    def update
      if @user.update(user_params)
        flash[:notice] = t('flashes.inquiries.update.notice')
        UserAccountMailer.with(user: @user).send("background_check_#{@user.background_check_status}").deliver_later
        redirect_to admin_inquiries_path
      else
        flash.now[:alert] = t('flashes.inquiries.update.alert')
        render 'edit'
      end
    end

    private

    def initialize_user
      @user = User.find_by(slug: params[:id])
    end

    def user_params
      params.require(:user)
            .permit(:background_check_status)
    end

    def valid_inquiry_status?
      flash.now[:alert] = t('flashes.inquiries.update.alert')
      render 'edit' if User.background_check_statuses[params.dig('user', 'background_check_status')] < 2
    end
  end
end
