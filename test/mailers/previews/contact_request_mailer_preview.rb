# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer

class ContactRequestMailerPreview < ActionMailer::Preview
  def notify_property_without_professional
    ContactRequestMailer.notify_property_without_professional(user: co_borrower, property: { 'area' => 'Ventura' })
  end

  def notify_contact_realtor
    ContactRequestMailer.notify_contact_realtor(professional: agent, user: co_borrower, address: '123, Main Street',
                                                channel_sid: 'asdf123')
  end

  def notify_concierge
    ContactRequestMailer.notify_concierge(professional: agent, user: co_borrower, address: '123, Main Street',
                                          phone_number: '+523121234567')
  end

  private

  def agent
    User.new(email: 'sergio@cher.app', password: 'Password1', role: :agent, first_name: 'Sergio', plan_type: 'lite', id: 1, slug: 'sergio-agent-cher-app', areas: ['Santa Monica'])
  end

  def co_borrower
    User.new(email: 'miguel@cher.app', password: 'Password1', role: :co_borrower, first_name: 'Miguel')
  end
end
