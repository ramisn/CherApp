# frozen_string_literal: true

class RemoveSendgridJob < ApplicationJob
  queue_as :default

  def perform(contact_id, list_id)
    RemoveSendgridService.new.process(contact_id, list_id)
  end
end
