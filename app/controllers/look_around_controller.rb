# frozen_string_literal: true

class LookAroundController < ApplicationController
  def index
    respond_to do |format|
      format.html { @properties_hash = build_properties_hash }
      format.json do
        json_response = LookAround::PropertiesJsonResponseService.new(current_user, search_params).execute
        registry_user_search if json_response[:properties].any?
        render json: json_response.merge(html: build_html_container)
      end
    end
  end

  private

  def build_properties_hash
    if params[:my_flagged_homes]
      LookAround::FindFlaggedPropertiesService.new(current_user).execute
    else
      LookAround::FindFeaturePropertiesService.new(current_user).execute
    end
  end

  def registry_user_search
    return unless user_signed_in?

    SearchHistoryService.new(sanitized_city_search, current_user).save_history
  end

  def build_html_container
    container_locals = LookAround::PropertiesContainerLocalsService.new(current_user, search_params).execute
    render_to_string('look_around/_properties_container.html.haml',
                     layout: false,
                     locals: container_locals)
  end

  def sanitized_city_search
    search_params[:search_in]&.sub(/, ..(, USA)?/, '')
  end

  def search_params
    params.require(:search)
          .permit(:amount, :search_in, :search_type, :minprice, :home_type,
                  :maxprice, :minbeds, :minbaths, :minyear, :maxyear, :maxarea,
                  :minarea, :minacres, :maxacres, :water, :maxdom, :startdate,
                  :start_hour, :start_minute, :points,
                  :features, :exteriorFeatures, type: [], status: [])
          .merge(limit: 500)
          .reject { |_, value| value.blank? }
  end
end
