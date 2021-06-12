# frozen_string_literal: true

class CreateFlaggedPropertyNotificationJob < ApplicationJob
  queue_as :default

  def perform(flagged_property)
    Notification.registry_flagged_property(flagged_property)
  end
end
