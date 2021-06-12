# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'cher@cher.app'
  layout 'trans_mailer'

  def check_bounces(email)
    contact = Contact.lookup(email)

    contact&.bounce?
  end

  def accepts_property_notification?(contact, property_id)
    (contact &&
      (!contact.accept_notification?(type: :home_share, method: :email) || !contact.accepts_property_notification?(property_id)))
  end
end
