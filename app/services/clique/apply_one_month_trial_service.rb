# frozen_String_literal: true

module Clique
  class ApplyOneMonthTrialService
    def initialize(user, code)
      @user = user
      @code = code
    end

    def execute
      if user_can_use_code?
        update_user_plan_data
        OpenStruct.new(success?: true, message: I18n.t('flashes.payment.enjoy_trial'))
      else
        OpenStruct.new(success?: false, message: I18n.t('flashes.payment.code_already_used'))
      end
    end

    private

    def update_user_plan_data
      @user.promo_codes << promo_code
      @user.end_of_clique = Date.today + 30.days
      @user.plan_type = 'premium'
      @user.message_credits = 5
      @user.save!
    end

    def user_can_use_code?
      # This code can be used only once
      !@user.promo_codes.where(name: @code).exists?
    end

    def promo_code
      @promo_code ||= PromoCode.find_by(name: @code)
    end
  end
end
