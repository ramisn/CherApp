# frozen_string_literal: true

class MailchimpCallbackController < ApplicationController
  protect_from_forgery with: :null_session

  def new
    if params[:type] == 'unsubscribe'
      contact = Contact.lookup(params['data']['email'])
      if contact && !contact.unsubscribe?
        contact.unsubscribe!
        DeleteMailchimpService.new.process contact.email
        contact.contactable.mailchimp_pending!
      end
    end

    render json: {}, status: 200
  end
end
