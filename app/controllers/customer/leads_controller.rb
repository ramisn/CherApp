# frozen_string_literal: true

module Customer
  class LeadsController < BaseController
    before_action :verify_clique
    before_action :serialize_user

    def index
      # Co-borrowers that we recommend customers to talk to
      @suggested_leads = User.suggested_leads(current_user)

      @suggested_leads = @suggested_leads.by_city(params[:city]) if params[:city].present?

      @suggested_leads = @suggested_leads.page(params[:page]).per(15)
    end

    private

    def serialize_user
      @user_serialized = UsersSerializer.new(current_user, scope: current_user).as_json
    end

    def verify_clique
      return redirect_to '/pricing', alert: I18n.t('dashboard.messages.clique_join') unless current_user.part_of_clique?
    end
  end
end
