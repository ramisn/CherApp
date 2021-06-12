# frozen_string_literal: true

require 'rest-client'

class SendgridEmailValidationService
  def self.validate(email, source = 'invite')
    return 'Valid' unless Rails.env.production?

    request = request(email, source)

    verdict = JSON.parse(request)['result']['verdict']

    Contact.find_or_create_by_prospect(email: email, status: 'risky', skip_sync: true) if verdict != 'Valid'

    verdict
  rescue RestClient::NotAcceptable => _e
    'Valid'
  end

  def self.data_body(email, source)
    { email: email, source: source }.to_json
  end

  def self.request(email, source)
    RestClient::Request.execute(method: :post, url: 'https://api.sendgrid.com/v3/validations/email',
                                headers: { 'Content-Type': 'application/json', 'Authorization': "Bearer #{ENV['SENDGRID_VALIDATION_API_KEY']}" },
                                payload: data_body(email, source))
  end
end
