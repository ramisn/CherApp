# frozen_string_literal: true

class ProspectsController < ApplicationController
  def create
    response = CreateProspectService.new(prospect_params, notify: params[:send_email]).execute
    respond_to do |format|
      format.html do
        flash[response.message_key] = response.message
        redirect_to root_path
      end
      format.json do
        render json_response(response)
      end
    end
  end

  private

  def prospect_params
    params.require(:prospect).permit(:email, :phone_number, :first_name, :last_name)
  end

  def json_response(response)
    if response.success?
      { json: response.prospect }
    else
      { json: { errors: response.errors }, status: 409 }
    end
  end
end
