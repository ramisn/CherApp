# frozen_string_literal: true

module Clique
  class NotifyPaymentFailedService
    def initialize(payment_data)
      @payment_data = payment_data
    end

    def call
      SendPaymentFailedNotificationJob.perform_later(user)
    end

    private

    def user
      customer_id = @payment_data.dig(:data, :object, :customer)
      user_email = Stripe::Customer.retrieve(customer_id).email

      User.find_by(email: user_email)
    end
  end
end
