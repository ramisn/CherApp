# frozen_string_literal: true

class BounceEventsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    json = JSON.parse(request.raw_post)
    logger.info "bounce callback from AWS with #{json}"
    aws_needs_url_confirmed = json['SubscribeURL']
    if aws_needs_url_confirmed
      confirm_with_ses(aws_needs_url_confirmed)
    else
      logger.info "AWS has sent us the following bounce notification(s): #{json}"
      bounce_emails(json)
    end
    render nothing: true, status: 200
  end

  private

  def confirm_with_ses(aws_needs_url_confirmed)
    logger.info 'AWS is requesting confirmation of the bounce handler URL'
    uri = URI.parse(aws_needs_url_confirmed)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.get(uri.request_uri)

    true
  end

  def bounce_emails(json)
    json['bounce']['bouncedRecipients'].each do |recipient|
      logger.info "AWS SES received a bounce on an email send attempt to #{recipient['emailAddress']}"
      BounceService.new(recipient['emailAddress']).execute
    end
  end
end
