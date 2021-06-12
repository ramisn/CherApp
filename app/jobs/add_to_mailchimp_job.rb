# frozen_string_literal: true

class AddToMailchimpJob < ApplicationJob
  queue_as :default

  def perform(email, role)
    AddToMailchimpService.new.process(email, role)
  end
end
