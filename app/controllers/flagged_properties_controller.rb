# frozen_string_literal: true

class FlaggedPropertiesController < AuthenticationsController
  include FlaggedPropertiesConcern

  def index
    respond_to do |format|
      format.json do
        render json: current_user.flagged_properties_data
      end
      format.html do
        @flagged_properties = PropertiesLocalInformationAppenderService.new(current_user.flagged_properties_data).execute
      end
    end
  end

  def create
    flagged_property = initialize_flagged_property
    respond_to do |format|
      if flagged_property.save
        SendFlaggedHouseNotificationJob.perform_later(params[:property_id], current_user, sanitized_city) if current_user.co_borrower?
        format.json { render json: { property_id: flagged_property.id }, status: :ok }
      else
        format.json { render json: { errors: flagged_property.errors }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    flagged_property = FlaggedProperty.find_by(property_id: params[:id], user_id: current_user.id)
    respond_to do |format|
      if flagged_property.destroy
        flash[:notice] = 'Property successfully unflagged'
        format.json { render json: { property: flagged_property }, status: :ok }
      else
        format.json { render json: { errors: flagged_property.errors }, status: :unprocessable_entity }
        flash[:alert] = 'Error unflagging property'
      end
      format.html { redirect_back fallback_location: root_path }
    end
  end

  private

  def sanitized_city
    params[:city].sub(/, ..(, USA)?/, '').downcase
  end

  def initialize_flagged_property
    FlaggedProperty.find_or_initialize_by(property_id: params[:property_id],
                                          city: sanitized_city,
                                          user_id: current_user.id,
                                          price_on_flag: params[:price])
  end
end
