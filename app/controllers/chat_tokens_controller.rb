# frozen_string_literal: true

class ChatTokensController < AuthenticationsController
  skip_before_action :authenticate_user!, only: :create

  require 'twilio-ruby'
  ACCOUNT_SID = ENV['TWILIO_ACCOUNT_SID']
  API_KEY = ENV['TWILIO_API_KEY']
  API_SECRET = ENV['TWILIO_API_SECRET']
  SERVICE_SID = ENV['TWILIO_SERVICE_SID']

  def create
    respond_to do |format|
      format.json { render json: generate_token }
    end
  end

  private

  def generate_token
    identity = current_user&.email || session[:concierge_sid]
    grant = Twilio::JWT::AccessToken::ChatGrant.new
    grant.service_sid = SERVICE_SID
    Twilio::JWT::AccessToken.new(ACCOUNT_SID, API_KEY, API_SECRET, [grant], identity: identity).to_jwt
  end
end
