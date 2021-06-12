# frozen_string_literal: true

module Customer
  module ProfileHelper
    def agent_needs_to_accept_referral?(user)
      user.estate_agent? && user.accept_referral_agreement.blank?
    end
  end
end
