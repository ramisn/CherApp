# frozen_string_literal: true

module CoBorrower
  class RentalsController < BaseController
    before_action :initialize_states
    require 'carmen'
    include Carmen

    def new
      @rental = current_user.rentals.build
    end

    def create
      @rental = current_user.rentals.new(rental_params)
      if @rental.save
        notify_rent
        flash[:notice] = t('flashes.rentals.create.notice')
        redirect_to co_borrower_dashboard_path
      else
        flash[:alert] = t('flashes.rentals.create.alert')
        render 'new'
      end
    end

    private

    def initialize_states
      @states = Country.named('United States')
                       .subregions
                       .typed('state').map(&:code)
    end

    def notify_rent
      RentNotificationMailer.notify_cher(current_user, @rental.id).deliver_later
      UserAccountMailer.with(user: current_user).listing_rental.deliver_later
    end

    def rental_params
      params.require(:rental)
            .permit(:address, :state, :monthly_rent, :security_deposit,
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
