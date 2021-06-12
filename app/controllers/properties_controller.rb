# frozen_string_literal: true

class PropertiesController < ApplicationController
  before_action :find_property, :find_flagged_properties, :registry_watch, only: %i[show]

  def index
    respond_to do |format|
      format.json do
        properties_response = PropertiesFinderService.new(sanitized_params, current_user, only_main_resource: true).execute
        properties = properties_response[:properties]
        flagged_properties_ids = flagged_properties_ids_by_user(properties)
        render json: { html: build_properties_container(properties, flagged_properties_ids, properties_response[:next_batch_link]),
                       properties: properties,
                       flagged_properties_ids: flagged_properties_ids }
      end
    end
  end

  # rubocop:disable Metrics/MethodLength
  def show
    respond_to do |format|
      format.html do
        return render 'not_found' unless @property

        @new_user = User.new
        @extra_data = extra_data
        @open_house = OpenhouseFinderService.new(@property['listingId']).execute
        @property_frankeinstein = PropertyFrankensteinGetterService.new(@property).execute
        @properties = [@property]
      end
      format.json do
        if @property
          render json: { property_data: PropertiesSerializer.new([@property]).serialize.first, html: build_property_container }
        else
          render json: @property, status: 404
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def build_property_container
    flagged_properties_ids = flagged_properties_ids_by_user([@property])
    render_to_string('shared/_property_container.html.haml', layout: false,
                                                             locals: { property: @property,
                                                                       flagged_properties_ids: flagged_properties_ids })
  end

  def build_properties_container(properties, flagged_properties_ids, next_batch_link)
    render_to_string('shared/_properties_cards.html.haml',
                     layout: false,
                     locals: {
                       properties: properties,
                       flagged_properties_ids: flagged_properties_ids,
                       next_batch_link: next_batch_link
                     })
  end

  def extra_data
    {
      similar_properties: FindSimilarPropertiesService.new(@property).execute,
      homebuyers: HomebuyersFinderService.new(params[:property_id], @property['address']['city'], current_user&.id).execute,
      user_flagged_property: current_user ? FlaggedProperty.find_flagged_by_user(@property['listingId'], current_user.id) : false
    }
  end

  def find_flagged_properties
    @flagged_properties = current_user.flagged_properties_data if current_user
  end

  def find_property
    @property = PropertyFinderService.new(params.to_unsafe_h).execute
  end

  def flagged_properties_ids_by_user(properties)
    FlaggedPropertiesIdsFinderService.new(properties, current_user&.id).execute
  end

  def sanitized_params
    next_batch_link = URI.parse(params[:link])
    search_params = CGI.parse(next_batch_link.query).symbolize_keys
    search_params.merge(search_in: search_params[:search_in][0])
  end

  def registry_watch
    return unless user_signed_in?

    seen_property_params = { property_id: params[:id], city: @property.dig('address', 'city') }
    current_user.seen_properties.find_or_create_by(seen_property_params)
  end
end
