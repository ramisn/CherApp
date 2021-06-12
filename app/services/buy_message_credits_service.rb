# frozen_string_literal: true

class BuyMessageCreditsService
  def initialize(professional)
    @professional = professional
  end

  def execute
    return response(false, I18n.t('flashes.message_credits.not_clique')) unless @professional.part_of_clique?

    @customer = stripe_customer
    return response(false, I18n.t('flashes.message_credits.no_customer')) unless @customer

    buy_credits
  rescue Stripe::CardError => e
    response(false, e.message)
  end

  private

  def buy_credits
    charge = Stripe::Charge.create(
      customer: @customer.id,
      amount: 9_900,
      description: '3 Message Credits',
      currency: 'usd'
    )

    @professional.update(message_credits: @professional.message_credits + 3)

    response(true, I18n.t('flashes.message_credits.paid_successfully'), charge)
  end

  def stripe_customer
    return unless @professional && @professional.email.present? && @professional.part_of_clique?

    Stripe::Customer.list(email: @professional.email).first
  end

  def response(success, message, charge = nil)
    OpenStruct.new(success?: success, message: message, charge: charge)
  end
end
