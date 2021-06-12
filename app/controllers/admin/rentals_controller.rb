# frozen_string_literal: true

module Admin
  class RentalsController < BaseController
    require 'carmen'
    include Carmen

    def show
      @states = Country.named('United States')
                       .subregions
                       .typed('state').map(&:code)
      @rental = Rental.find(params[:id])
    end

    def index
      @rentals = if params[:filter]
                   Rental.where(status: params[:filter].to_sym)
                 else
                   Rental.all
                 end
    end

    def edit
      @states = Country.named('United States')
                       .subregions
                       .typed('state').map(&:code)
      @rental = Rental.find(params[:id])
    end

    def update
      @rental = Rental.find(params[:id])
      if @rental.update(rental_params)
        flash[:notice] = t('flashes.rentals.update.notice')
        redirect_to admin_rentals_path
      else
        flash[:alert] = t('flashes.rentals.updates.alert')
        rener 'edit'
      end
    end

    private

    def rental_params
      params.require(:rental)
            .permit(:address, :state, :monthly_rent, :security_deposit, :status,
                    :bedrooms, :bathrooms, :square_feet, :date_available,
                    :lease_duration, :hide_address, :ac, :balcony_or_deck,
                    :furnished, :hardwood_floor, :wheelchair_access,
                    :garage_parking, :off_street_parking, :additional_amenities,
                    :laundry, :pertmit_pets, :permit_cats, :permit_small_dogs,
                    :permit_large_dogs, :about, :lease_summary, :name,
                    :email, :phone_number, :listed_by_type, images: [])
    end
  end
end
