# frozen_string_literal: true

require 'application_system_test_case'

class CheckoutTest < ApplicationSystemTestCase
  # Commented while we check what to do with the request from StripeJS
  # test 'new user can sign up with ' do
  #   WebStub.stub_stripe_customer_list
  #   WebStub.stub_stripe_customer_creation
  #   WebStub.stub_stripe_payment_method_creation
  #   WebStub.stub_stripe_customer_payment_attach
  #   WebStub.stub_stripe_payment_method_creation
  #   WebStub.stub_stripe_subscription_creation
  #   WebStub.stub_stripe_invoice
  #   WebStub.stub_stripe_payment_intent
  #   WebStub.stub_twilio_chat_response
  #   WebStub.stub_twilio_chat_response
  #   visit customer_checkout_index_path

  #   assert_content '$199'

  #   fill_in 'firstName', with: 'Gerald'
  #   fill_in 'lastName', with: 'Amezcua'
  #   fill_in 'email', with: 'gerald@amezcua.com'
  #   fill_expity '1124'
  #   fill_card '4242424242424242'
  #   fill_cvc '123'

  #   click_button 'Proceed'

  #   using_wait_time(10) do
  #     assert_content 'Payment succeeded', wait: 10
  #   end
  # end

  private

  def fill_expity(expiry)
    using_wait_time(10) do
      frame = find('#card-expiry iframe')
      within_frame(frame) do
        find_field('exp-date').send_keys expiry
      end
    end
  end

  def fill_cvc(cvc)
    using_wait_time(10) do
      frame = find('#card-cvc iframe')
      within_frame(frame) do
        find_field('cvc').send_keys cvc
      end
    end
  end

  def fill_card(card)
    using_wait_time(10) do
      frame = find('#card-number iframe')
      within_frame(frame) do
        card.to_s.chars.each do |piece|
          find_field('cardnumber').send_keys(piece)
        end
      end
    end
  end
end
