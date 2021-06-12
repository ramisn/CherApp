# frozen_string_literal: true

class TagMailchimpJob < ApplicationJob
  queue_as :default

  def perform(email, role, status = 'active')
    TagMailchimpService.new.process(email, role, status)
  end
end
