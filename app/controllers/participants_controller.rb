# frozen_string_literal: true

class ParticipantsController < AuthenticationsController
  skip_before_action :authenticate_user!

  def index
    participants = FetchChannelParticipantsService.new(current_user, params[:message_channel_id]).execute
    respond_to do |format|
      format.json { render json: participants, each_serializer: UsersSerializer }
    end
  end

  def destroy
    MessageChannel.remove_participant_from_channel(params[:message_channel_id], params[:id])
  end
end
