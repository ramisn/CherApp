# frozen_String_literal: true

module Clique
  class ApplyCliquePromoCodeService
    def initialize(user, promo_code)
      @user = user
      @promo_code = promo_code
    end

    def execute
      promo_code = PromoCode.find_by(name: @promo_code)
      if promo_code
        "Clique::Apply#{promo_code.class_name}Service".constantize.new(@user, @promo_code).execute
      else
        OpenStruct.new(success?: false, message: I18n.t('flashes.payment.invalid_promo_code'))
      end
    end
  end
end
