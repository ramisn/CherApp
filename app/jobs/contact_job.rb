# frozen_string_literal: true

class ContactJob < ApplicationJob
  queue_as :default

  def perform(contact)
    sendgrid_token
    CreateContactService.new.process(contact)
  end

  def sendgrid_token
    token = Redis.current.get('sendgrid_token')
    case token
    when nil
      Redis.current.set('sendgrid_token', 1)
      true
    when 0
      Redis.current.set('sendgrid_token', 1)
      true
    when '1'
      raise 'noTokenAvailable'
    else
      true
    end
  end
end
