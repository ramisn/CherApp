# frozen_string_literal: true

module Clique
  class DeleteSubscriptionService
    def initialize(current_user, id = nil)
      @current_user = current_user
      @subscription_id = id || user_subscription_id
    end

    def execute
      return nil unless @current_user.part_of_clique?
      return nil unless @subscription_id

      Stripe::Subscription.delete(@subscription_id)
      SendBillingCancelledJob.perform_later(@current_user)
    end

    private

    def user_subscription_id
      return nil unless stripe_customer

      subscription = stripe_customer.subscriptions['data'].first
      subscription ? subscription.id : nil
    end

    def stripe_customer
      Stripe::Customer.list(limit: 1, email: @current_user.email)['data'].first
    end
  end
end
