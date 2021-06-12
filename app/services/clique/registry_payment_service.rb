# frozen_string_literal: true

module Clique
  class RegistryPaymentService
    def initialize(payment_data)
      @payment_data = payment_data
    end

    def call
      Payment.create!(user: user,
                      transaction_id: @payment_data.dig(:data, :object, :id),
                      receipt_url: @payment_data.dig(:data, :object, :charges, :data, 0, :receipt_url),
                      amount: @payment_data.dig(:data, :object, :amount))
      user.update!(end_of_clique: Date.today + 30.days, plan_type: 'premium', message_credits: 5)
      SendPaymentNotificationJob.perform_later(@user)
    end

    private

    def user
      @user ||= User.find_by(email: user_email)
    end

    def user_email
      customer_id = @payment_data.dig(:data, :object, :customer)
      Stripe::Customer.retrieve(customer_id).email
    end
  end
end
