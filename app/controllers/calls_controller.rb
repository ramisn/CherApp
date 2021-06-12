# frozen_string_literal: true

class CallsController < ApplicationController
  PHONE_NUMBER_REGEX = /^\d{10}$/.freeze

  def create
    response_mesasge = if user_phone_number_is_valid?
                         CallRequestMailer.notify_admin(@user_phone_number).deliver_later
                         t('calls.new.success')
                       else
                         t('calls.new.error')
                       end
    render json: response_mesasge
  end

  private

  def user_phone_number_is_valid?
    @user_phone_number = call_params[:phone_number]
    @user_phone_number.match(PHONE_NUMBER_REGEX)
  end

  def call_params
    params.require(:call).permit(:phone_number)
  end
end
