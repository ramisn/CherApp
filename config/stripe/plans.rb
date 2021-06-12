# frozen_string_literal: true

Stripe.plan :premium do |plan|
  plan.name = 'CHER premium'
  plan.amount = 19_900
  plan.interval = 'month'
end
