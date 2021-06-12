# frozen_string_literal: true

class TextMessagesController < ApplicationController
  def create
    respond_to do |format|
      format.json do
        if recipient_valid?
          SendShareableTextMessageJob.perform_later(message_params)
          render json: { message: t('flashes.sms.create.success') }, status: 200
        else
          render json: { message: t('flashes.emails.create.alert') }, status: 400
        end
      end
    end
  end

  private

  def message_params
    params.require(:text_message)
          .permit(:link,
                  :recipient,
                  :message,
                  :type,
                  :user_name,
                  :recipient_name,
                  :address,
                  :ending)
  end

  def recipient_valid?
    params[:text_message][:recipient].strip.match(/\d{10}/)
  end
end
