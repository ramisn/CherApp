# frozen_string_literal: true

require 'test_helper'

class PaymentMailerTest < ActionMailer::TestCase
  test 'it success sending free plan email' do
    agent = users(:agent_user)
    mail = PaymentMailer.free_plan_notification(agent)

    assert_equal 'Cher Clique free access success', mail.subject
    assert_match 'Thanks Agent User for being part of Cher', mail.body.encoded
    assert_equal ['cher@cher.app'], mail.from
    assert_equal [agent.email], mail.to
  end

  test 'it success sending payment error email' do
    agent = users(:agent_user)
    mail = PaymentMailer.recurrent_payment_error(agent)

    assert_equal 'Your Payment Was Declined — Update Now', mail.subject
    assert_match 'Unfortunately, we are having trouble processing payment', mail.body.encoded
    assert_match 'Thank you for subscribing to Cher Premium Agent', mail.body.encoded
    assert_equal ['cher@cher.app'], mail.from
    assert_equal [agent.email], mail.to
  end

  test 'it usccess send subscription canceled mail' do
    agent = users(:agent_user)
    mail = PaymentMailer.cancel_subscription(agent)

    assert_equal '50% off or Confirm Your Cancellation', mail.subject
    assert_match 'Dear Agent User User,', mail.body.encoded
    assert_match 'This is a confirmation email that your subscription', mail.body.encoded
    assert_equal ['cher@cher.app'], mail.from
    assert_equal [agent.email], mail.to
  end
end
