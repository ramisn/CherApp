# frozen_string_literal: true

module Customer
  class MessageCreditsController < BaseController
    def new; end

    def create
      result = BuyMessageCreditsService.new(current_user).execute

      if result.success?
        flash[:notice] = result.message
      else
        flash[:alert] = result.message
      end

      redirect_to customer_dashboard_path
    end
  end
end
