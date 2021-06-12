# frozen_string_literal: true

module Users
  class ActivationsController < ApplicationController
    def new; end

    def create
      @user = User.find_by(email: activation_params[:email])
      return render 'new' unless valid_user?

      @user.update(discard_token: Devise.friendly_token[0, 20])
      ActivationsMailer.notify_user(@user).deliver_later
      flash[:notice] = t('flashes.activations.create.notice')
      redirect_to root_path
    end

    def edit
      @user = User.find_by(discard_token: params[:discard_token])
      if @user
        @user.undiscard
        flash[:notice] = t('flashes.activations.update.notice')
        redirect_to new_user_session_path
      else
        flash[:alert] = t('flashes.activations.update.alert')
        redirect_to root_path
      end
    end

    private

    def activation_params
      params.require(:activation).permit(:email)
    end

    def valid_user?
      if @user.nil?
        flash[:alert] = t('flashes.activations.create.user_not_found')
        false
      elsif !@user.discarded?
        flash[:alert] = t('flashes.activations.create.alert')
        false
      else
        true
      end
    end
  end
end
