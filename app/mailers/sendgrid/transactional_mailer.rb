# frozen_string_literal: true

require 'rest-client'

module Sendgrid
  class TransactionalMailer
    def initialize(sender:,
                   subject:,
                   template_id:,
                   dynamic_template_data:,
                   destinatary:)
      @sender = sender
      @subject = subject
      @template_id = template_id
      @dynamic_template_data = dynamic_template_data
      @destinatary = destinatary
    end

    def send_message!
      RestClient::Request.execute(method: :post, url: 'https://api.sendgrid.com/v3/mail/send',
                                  headers: { 'Content-Type': 'application/json',
                                             'Authorization': "Bearer #{ENV['SENDGRID_TRANS_API_KEY']}" },
                                  payload: request_payload)
    rescue RestClient::ExceptionWithResponse => e
      return false if e.message.include?('401')
    end

    private

    attr_accessor :sender, :subject, :template_id, :dynamic_template_data, :destinatary

    def request_payload
      {
        from: { name: sender[:name], email: sender[:email] },
        personalizations: [{ to: [{ name: destinatary[:name], email: destinatary[:email] }], dynamic_template_data: dynamic_template_data }],
        subject: subject,
        template_id: template_id
      }.to_json
    end
  end
end
