# frozen_string_literal: true

module CoBorrower
  class HousesController < BaseController
    before_action :initialize_states
    before_action :set_draft, only: :create

    require 'carmen'
    include Carmen

    def new
      @house = current_draft || current_user.houses.build
      flash[:notice] = t('flashes.houses.opened_draft.notice') if current_draft
    end

    def create
      @house = build_house
      if @house.save
        if save_draft_clicked?
          flash[:notice] = t('flashes.houses.save.notice')
        else
          SellNotificationMailer.notify_cher(current_user.full_name, @house.id).deliver_later
          flash[:notice] = t('flashes.houses.create.notice')
        end
        redirect_to co_borrower_dashboard_path
      else
        flash[:alert] = t('flashes.houses.create.alert')
        render 'new'
      end
    end

    private

    def build_house
      house = current_draft || current_user.houses.new(house_params)

      house.assign_attributes(house_params) if current_draft
      return house if params[:users_ids].blank?

      params[:users_ids].each { |user_id| house.users << User.find(user_id) }
      house
    end

    def house_params
      params.require(:house)
            .permit(:address, :state, :zipcode, :county, :price,
                    :ownership_percentage, :home_type, :beds, :full_baths,
                    :half_baths, :interior_area, :lot_size, :hoa_dues,
                    :basement_area, :garage_area, :description, :year_build,
                    :start_hour_for_open_house, :end_hour_for_open_house,
                    :website, :details, :email_contact, :phone_contact,
                    :selling_percentage, :down_payment, :monthly_mortgage,
                    :status, :accept_terms, :receive_analysis, :draft,
                    :date_for_open_house, images: [])
            .merge(date_for_open_house: parsed_date)
    end

    def initialize_states
      @states = Country.named('United States')
                       .subregions
                       .typed('state').map(&:code)
    end

    def parsed_date
      given_date = params[:house][:date_for_open_house]
      given_date.blank? ? nil : Date.strptime(given_date, '%m/%d/%Y')
    end

    def set_draft
      params['house']['draft'] = save_draft_clicked?
    end

    def current_draft
      @current_draft ||= current_user.houses.draft.first
    end

    def save_draft_clicked?
      params['commit'] == t('generic.save_draft')
    end
  end
end
