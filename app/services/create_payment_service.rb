# frozen_string_literal: true

class CreatePaymentService
  CLIQUE_PRICE_ID = ENV['CLIQUE_PRICE_ID']

  def initialize(params, current_user)
    @payment_method_id = params[:payment_method_id]
    @plan_type = params[:plan_type]
    @user = current_user
    @coupon = params[:coupon]
  end

  def execute
    generate_response(build_payment)
  rescue Stripe::CardError => e
    { error: e.message }
  end

  private

  def generate_response(intent)
    if intent.status == 'requires_action' && intent.next_action.type == 'use_stripe_sdk'
      { requires_action: true, payment_intent_client_secret: intent.client_secret }
    elsif intent.status == 'succeeded'
      { success: true, payment_intent_id: intent.id, message: I18n.t('flashes.payment.create.success') }
    else
      { error: I18n.t('flashes.payment.create.error') }
    end
  end

  def build_payment
    subscription = create_and_subscribe_customer
    invoice = Stripe::Invoice.retrieve(subscription.latest_invoice)
    Stripe::PaymentIntent.retrieve(invoice.payment_intent)
  end

  def create_and_subscribe_customer
    customer = find_or_create_customer
    # If customer exists but have no default method
    attach_payment_method(customer) unless payment_method_defined?(customer)
    Stripe::Subscription.create(customer: customer.id, items: [{ price: CLIQUE_PRICE_ID }], coupon: @coupon)
  end

  def attach_payment_method(customer)
    Stripe::PaymentMethod.attach(@payment_method_id, customer: customer.id)
    Stripe::Customer.update(customer.id, invoice_settings: { default_payment_method: @payment_method_id })
  end

  def payment_method_defined?(customer)
    !customer.invoice_settings.default_payment_method.blank?
  end

  def find_or_create_customer
    customer_response = Stripe::Customer.list(limit: 1, email: @user.email)
    return customer_response['data'].first unless customer_response['data'].blank?

    Stripe::Customer.create(description: 'Clique agent',
                            email: @user.email,
                            name: @user.full_name,
                            payment_method: @payment_method_id,
                            invoice_settings: { default_payment_method: @payment_method_id })
  end
end
