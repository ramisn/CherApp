# frozen_string_literal: true

class SendPaymentNotificationJob < ApplicationJob
  queue_as :default

  def perform(user)
    calendly_url = BitlyClient.short_url('https://calendly.com/joincher/agent?back=1&month=2021-02&utm_source=email&utm_medium=emailCherPremiumAgent&utm_campaign=emailCher%20Premium%20Agenttext')
    sms_message = I18n.t("sms_notifications.cher_clique.#{user.plan_type}", first_name: user.first_name, calendly_url: calendly_url)
    UserAccountMailer.with(user: user).clique_payment_success.deliver_later
    SendSmsService.new(sms_message, user.phone_number, sms_type: :chers_clique).execute
  end
end
