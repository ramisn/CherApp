# frozen_string_literal: true

class ConciergeConversationsController < ApplicationController
  def create
    @response = CreateConciergeConversationService.new(session[:concierge_sid]).execute

    session[:concierge_sid] = @response.user_concierge_id

    respond_to do |format|
      format.json { render json: @response.to_json }
      format.html do
        render 'shared/conversations/not_found' unless TwilioChatUtils.channel_exists?(@conversation_id)
      end
    end
  end
end
