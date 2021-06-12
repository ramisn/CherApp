# frozen_string_literal: true

module PaymentHelper
  def payment_amount(amount)
    amount.to_s.insert(-3, '.')
  end
end
