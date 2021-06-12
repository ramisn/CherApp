# frozen_string_literal: true

module Customer
  class PaymentsController < ApplicationController
    def show
      @payment = Stripe::PaymentIntent.retrieve(params[:id])
    end

    def create
      response = if current_user
                   CreatePaymentService.new(params, current_user).execute
                 else
                   response = CreateNewUserPaymentService.new(params, cookies, request).execute
                   sign_in response[:user] if response[:user]

                   response
                 end

      render json: response
    end
  end
end
