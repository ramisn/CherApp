# frozen_string_literal: true

class SendShareableTextMessageJob < ApplicationJob
  queue_as :default

  def perform(message_params)
    SendShareableTextMessageNotificationService.new(message_params).execute
  end
end
