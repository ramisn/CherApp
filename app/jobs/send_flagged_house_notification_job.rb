# frozen_string_literal: true

class SendFlaggedHouseNotificationJob < ApplicationJob
  sidekiq_options retry: 1
  queue_as :default

  def perform(property_id, current_user, _city)
    property_address = SimplyRets.find_property_by_id(property_id).dig('address')
    FlaggedHomeNotificationService.new(current_user, property_address).execute
    SendFlaggedPropertyTextMessageService.new(current_user, property_id, property_address).execute
  end
end
