# frozen_string_literal: true

module Customer
  class CheckoutController < ApplicationController
    layout 'checkout/application'

    def index
      if current_user&.part_of_clique?
        flash.now[:notice] = t('flashes.payment.already_has_plan', end_date: current_user.end_of_clique)
        render 'pages/pricing'
      end

      @price = Stripe::Plans::PREMIUM.amount / 100
    end
  end
end
