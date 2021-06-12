# frozen_string_literal: true

class BounceService
  def initialize(email)
    @email = email
  end

  def execute
    contact = Contact.lookup(@email)
    contact = Contact.find_or_create_by_prospect(email: @email) if contact.nil?
    contact.bounce!
  end
end
