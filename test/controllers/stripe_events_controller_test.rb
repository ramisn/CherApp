# frozen_string_literal: true

require 'test_helper'

class StripeEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    agent = users(:agent_user)
    # Mock customer search
    WebMock.stub_request(:get, %r{https://api.stripe.com/v1/customers.*})
           .to_return(status: 200, body: { email: agent.email }.to_json)
  end

  test 'it creates a payment when success type' do
    # Skip signature validation
    Stripe::Webhook.stubs(:construct_event).returns(true)

    assert_difference 'Payment.count', 1 do
      post stripe_events_path, params: payment_success_data
    end
  end

  test 'it enqueue a notification job when payment success' do
    # Skip signature validation
    Stripe::Webhook.stubs(:construct_event).returns(true)

    assert_enqueued_with(job: SendPaymentNotificationJob) do
      post stripe_events_path, params: payment_success_data
    end
  end

  test 'it enqueue a email when error on payment' do
    # Skip signature validation
    Stripe::Webhook.stubs(:construct_event).returns(true)

    assert_enqueued_with(job: SendPaymentFailedNotificationJob) do
      post stripe_events_path, params: payment_fail_data
    end
  end

  test 'it does nothing when unexpected type' do
    # Skip signature validation
    Stripe::Webhook.stubs(:construct_event).returns(true)

    post stripe_events_path, params: { type: 'payment_intent.unexpected' }

    assert_enqueued_emails 0
    assert_enqueued_jobs 0
  end

  test 'it return bad request on signature errro' do
    post stripe_events_path, params: { type: 'payment_intent.unexpected' }

    assert_response :bad_request
  end

  private

  def payment_success_data
    {
      type: 'payment_intent.succeeded',
      data: {
        object: { customer: '123abc', id: '123abc', amount: '99', charges: { data: [{ receipt_url: 'stripe/receipt/123' }] } }
      }
    }
  end

  def payment_fail_data
    {
      type: 'payment_intent.payment_failed',
      data: {
        object: { customer: '123abc' }
      }
    }
  end
end
