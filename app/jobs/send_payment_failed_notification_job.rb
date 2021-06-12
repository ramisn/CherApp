# frozen_string_literal: true

class SendPaymentFailedNotificationJob < ApplicationJob
  queue_as :default

  def perform(user)
    sms_message = I18n.t('sms_notifications.cher_clique.payment_failed', first_name: user.first_name)
    PaymentMailer.recurrent_payment_error(user).deliver_later
    SendSmsService.new(sms_message, user.phone_number, sms_type: :chers_clique).execute
  end
end
