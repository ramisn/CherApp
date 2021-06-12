# frozen_string_literal: true

require 'test_helper'

class FindLast4ServiceTest < ActiveSupport::TestCase
  setup do
    WebStub.stub_stripe_customer
    WebStub.stub_stripe_customer_last_4
    @premium_agent = users(:clique_agent)
    @user = users(:co_borrower_user)
    @agent_without_premium = users(:agent_user)
  end

  test 'it returns only 4 last digits' do
    last4 = FindLast4Service.new(@premium_agent).execute

    assert_equal '4242', last4
  end

  test 'it returns nil when the user is not an agent' do
    last4 = FindLast4Service.new(@user).execute

    assert_nil last4
  end

  test "it returns nil when the user don't have a premium account" do
    last4 = FindLast4Service.new(@agent_without_premium).execute

    assert_nil last4
  end
end
