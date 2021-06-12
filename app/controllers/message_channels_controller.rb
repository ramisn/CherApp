# frozen_string_literal: true

class MessageChannelsController < AuthenticationsController
  before_action :find_users_channel, only: %i[show]

  def show
    if @channel
      render json: @channel
    else
      render json: { errors: t('errors.channel_messages.not_found') }, status: 404
    end
  end

  def create
    channel = MessageChannel.new(channel_params_with_participants)
    if channel.save
      render json: channel
    else
      render json: channel.errors, status: 422
    end
  end

  def update
    channel = MessageChannel.find_by(sid: params[:id])
    if channel.update(channel_params)
      ProfessionalContactChannelUpdaterService.new(channel, current_user).execute if channel.saved_change_to_status
      render json: channel, status: 200
    else
      render json: channel.errors, status: 400
    end
  end

  private

  def user
    @user ||= User.find(params[:user_id])
  end

  def find_users_channel
    @channel = if params[:user_id]
                 MessageChannel.where('participants = ARRAY[?]::varchar[]', [current_user.email, user.email])
                               .or(MessageChannel.where('participants = ARRAY[?]::varchar[]', [user.email, current_user.email]))
                               .first
               else
                 MessageChannel.find_by(sid: params[:id])
               end
  end

  def channel_params
    params.require(:channel)
          .permit(:sid, :status, :purpose)
  end

  def channel_params_with_participants
    channel_params.merge(participants: [current_user.email, user.email])
  end
end
