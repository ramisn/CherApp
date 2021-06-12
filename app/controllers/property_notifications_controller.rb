# frozen_string_literal: true

class PropertyNotificationsController < AuthenticationsController
  def update
    result = TogglePropertyNotificationService.new(current_user, params[:id]).execute
    respond_to do |format|
      format.html { redirect_to property_path(params[:id]), notice: result.message }
      format.json { render json: result.to_h.to_json }
    end
  end
end
