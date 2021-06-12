# frozen_string_literal: true

class EmailsController < ApplicationController
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze

  def create
    respond_to do |format|
      format.json do
        if valid_email?
          ActivityMailer.send("share_#{params[:email][:type]}", email_params, current_user).deliver

          render json: { message: t('flashes.emails.create.success') }, status: 200
        else
          render json: { message: t('flashes.emails.create.alert') }, status: 400
        end
      end
    end
  end

  private

  def email_params
    params.require(:email).permit(:recipient, :body, :link, :type, :address, :recipient_name, :user_name)
  end

  def valid_email?
    params[:email][:recipient].match?(VALID_EMAIL_REGEX)
  end
end
