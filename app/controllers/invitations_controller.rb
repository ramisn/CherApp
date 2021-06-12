# frozen_string_literal: true

class InvitationsController < ApplicationController
  before_action :authenticate_user!

  def create
    respond_to do |format|
      format.json do
        render json: {}, status: invite_user ? 200 : 400
      end
      format.html do
        if invite_user
          flash[:notice] = t('flashes.invitation.create.notice')
        else
          flash[:alert] = t('flashes.invitation.create.error', email: params[:email])
        end
        redirect_back fallback_location: root_path
      end
    end
  end

  private

  def invite_user
    if params[:email]
      return false if User.find_by_email(params[:email])

      User.invite!({ email: params[:email] }, current_user)
    elsif params[:emails]
      params[:emails].each do |email|
        User.invite!({ email: email }, current_user)
      end
    end
  end
end
