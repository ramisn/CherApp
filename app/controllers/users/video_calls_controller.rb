# frozen_string_literal: true

module Users
  class VideoCallsController < AuthenticationsController
    before_action :define_channel_sid, only: %i[show create destroy]

    def show
      render 'shared/conversations/not_found' unless TwilioChatUtils.channel_exists?(@channel_sid)
    end

    # join video call
    def create
      video_call = JoinVideoCallService.new(current_user, @channel_sid).execute

      render json: video_call.to_h, status: video_call.status
    end

    # end video call
    def destroy
      DeleteVideoCallService.new(@channel_sid).execute

      head :no_content
    end

    private

    def define_channel_sid
      @channel_sid = params[:channel_sid]
    end
  end
end
