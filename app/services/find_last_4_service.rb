# frozen_string_literal: true

class FindLast4Service
  def initialize(professional)
    @professional = professional
  end

  def execute
    return unless @professional && @professional.email.present? && @professional.part_of_clique?

    stripe_customer = Stripe::Customer.list(email: @professional.email).first
    return nil unless stripe_customer

    payment_method = Stripe::PaymentMethod.list(customer: stripe_customer.id, type: 'card').first
    payment_method.card.last4
  end
end
