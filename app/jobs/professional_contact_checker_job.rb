# frozen_string_literal: true

class ProfessionalContactCheckerJob < ApplicationJob
  queue_as :default

  def perform(requester, params)
    ProfessionalContactCheckerService.new(requester, params).execute
  end
end
