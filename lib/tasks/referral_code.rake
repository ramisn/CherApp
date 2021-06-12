# frozen_string_literal: true

namespace :referral_code do
  task set_to_users_without_code: :environment do
    users_without_referral_code = User.where(referral_code: nil)
    users_without_referral_code.each do |user|
      user.update(referral_code: Devise.friendly_token(50))
    end
  end
end
