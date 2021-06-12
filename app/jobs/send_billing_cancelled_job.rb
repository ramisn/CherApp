# frozen_string_literal: true

class SendBillingCancelledJob < ApplicationJob
  queue_as :default

  def perform(user)
    sms_message = I18n.t('sms_notifications.cher_clique.billing_canceled')
    PaymentMailer.cancel_subscription(user).deliver_later
    SendSmsService.new(sms_message, user.phone_number, sms_type: :chers_clique).execute
  end
end
