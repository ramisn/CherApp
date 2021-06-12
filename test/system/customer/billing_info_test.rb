# frozen_String_literal: true

require 'application_system_test_case'

class BillingInfoTest < ApplicationSystemTestCase
  setup do
    WebStub.stub_stripe_customer_list
    WebStub.stub_stripe_customer_creation
    WebStub.stub_stripe_customer_payment_methods
    ChatTokensController.any_instance
                        .stubs(:generate_token)
                        .returns('wOaRw3T5.IurTwe5g6.r56YGG352')
    agent = users(:agent_user)
    login_as agent
    visit customer_dashboard_path
  end

  test 'user can access to billing info' do
    click_link 'Clique settings'

    assert_content 'Payment method'
  end

  test 'user can update current billing info' do
    WebStub.stub_stripe_payment_method_creation
    WebStub.stub_stripe_customer_payment_attach
    # Stub default payment method update
    WebStub.stub_stripe_customer_update

    click_link 'Clique settings'
    fill_in 'Card number', with: '5242424242424242'
    fill_in 'Expires date', with: '1124'
    fill_in 'CVC', with: '123'
    click_button 'Save'

    assert_content 'Payment method successfully updated'
  end

  test 'user can cancel Clique subscription' do
    WebStub.stub_stripe_subscription_removal

    click_link 'Clique settings'
    click_link 'Cancel my Clique Premium plan'
    page.driver.browser.switch_to.alert.accept

    assert_content 'You unsubscribed from Clique Premium'
  end

  test 'user cannot buy more credits if not has clique' do
    click_link 'Clique settings'
    WebStub.stub_stripe_charge
    WebStub.stub_stripe_customer_creation
    click_link 'Buy more credits'
    click_link 'Buy 3 credits'

    assert_content 'You need to be a Clique Premium Agent to buy credits'
  end

  test 'user cannot buy more credits if customer not available' do
    users(:agent_user).update(end_of_clique: 1.month.from_now)
    click_link 'Clique settings'
    WebStub.stub_stripe_charge
    WebStub.stub_stripe_customer_creation
    click_link 'Buy more credits'
    click_link 'Buy 3 credits'

    assert_content 'Customer not available'
  end
end
