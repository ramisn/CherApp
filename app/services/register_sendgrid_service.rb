# frozen_string_literal: true

class RegisterSendgridService < BaseSendgridService
  def process(email, type)
    return if %i[admin stage_agent].include? type

    RestClient::Request.execute(method: :put, url: 'https://api.sendgrid.com/v3/marketing/contacts',
                                headers: { 'Content-Type': 'application/json', 'Authorization': "Bearer #{ENV['SENDGRID_API_KEY']}" },
                                payload: data_body(email, type))

    mark_done(email)
  rescue StandardError => _e
    false
  end

  def data_body(email, type)
    { list_ids: [list[type]], contacts: [{ email: email }] }.to_json
  end

  def mark_done(email)
    contact = Contact.lookup(email)
    contact.contactable.sendrig_updated! if contact&.contactable
  end
end
