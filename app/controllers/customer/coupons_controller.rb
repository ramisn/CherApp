# frozen_string_literal: true

module Customer
  class CouponsController < BaseController
    def show
      respond_to do |format|
        format.json do
          coupon_id = params[:id]

          coupon = Stripe::Coupon.retrieve(coupon_id)
          render json: coupon.to_json
        rescue Stripe::InvalidRequestError => _e
          render json: { coupon_id: coupon_id }, status: 404
        end
      end
    end
  end
end
