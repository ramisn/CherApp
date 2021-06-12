# frozen_string_literal: true

class StripeEventsController < ApplicationController
  STRIPE_SIGNATURE = ENV['STRIPE_SIGNATURE']
  protect_from_forgery with: :null_session
  before_action :validate_signature

  def create
    case params[:type]
    when 'payment_intent.succeeded'
      # Registry Payment and set up user end_of_clique
      Clique::RegistryPaymentService.new(params).call
    when 'payment_intent.payment_failed'
      # Subscription is canceled in Stripe if all retries fails
      Clique::NotifyPaymentFailedService.new(params).call
    else
      head :no_content
    end
  end

  private

  def user
    customer_id = params.dig(:data, :object, :customer)
    cutomer_email = Stripe::Customer.retrieve(customer_id).email
    User.find_by!(email: cutomer_email)
  end

  def validate_signature
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    payload = request.body.read
    begin
      Stripe::Webhook.construct_event(payload, sig_header, STRIPE_SIGNATURE)
    rescue JSON::ParserError
      # Invalid payload
      head :bad_request
    rescue Stripe::SignatureVerificationError
      # Invalid signature
      head :bad_request
    end
  end
end
