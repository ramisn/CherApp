# frozen_String_literal: true

module Customer
  module BillingInfoHelper
    def card_number(card)
      return nil unless card

      "************#{card[:last4]}"
    end

    def card_expires_date(card)
      return nil unless card

      exp_year = card[:exp_year].to_s[2..4]
      exp_month = card[:exp_month]
      "#{exp_month}/#{exp_year}"
    end
  end
end
