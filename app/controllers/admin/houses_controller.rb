# frozen_string_literal: true

module Admin
  class HousesController < BaseController
    require 'carmen'
    include Carmen
    before_action :find_house, only: %i[show update edit]

    def index
      @houses = if params[:filter]
                  House.where(status: params[:filter].to_sym)
                else
                  House.all
                end
    end

    def show; end

    def edit
      @states = Country.named('United States')
                       .subregions
                       .typed('state').map(&:code)
    end

    def update
      if @house.update(house_params)
        flash[:notice] = t('flashes.houses.update.notice')
      else
        flash[:alert] = t('flashes.houses.update.alert')
      end
      redirect_to admin_houses_path
    end

    private

    def find_house
      @house = House.find(params[:id])
    end

    def house_params
      params.require(:house)
            .permit(:address, :state, :zipcode, :county, :price, :mlsid,
                    :ownership_percentage, :home_type, :beds, :full_baths,
                    :half_baths, :interior_area, :lot_size, :hoa_dues,
                    :basement_area, :garage_area, :description, :year_build,
                    :start_hour_for_open_house, :end_hour_for_open_house,
                    :website, :details, :email_contact, :phone_contact,
                    :status, :accept_terms, :receive_analysis, images: [])
            .merge(date_for_open_house: parsed_date)
    end

    def parsed_date
      given_date = params[:house][:date_for_open_house]
      given_date.blank? ? nil : Date.strptime(given_date, '%m/%d/%Y')
    end
  end
end
