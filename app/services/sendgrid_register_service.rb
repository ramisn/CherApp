# frozen_string_literal: true

class SendgridRegisterService
  def initialize(email, state)
    @email = email
    @state = state
  end

  def registry_event
    contact.send(:"#{state}!") unless contact.blank?
  end

  private

  def contact
    @contact ||= Contact.lookup(email: @email)
  end
end
