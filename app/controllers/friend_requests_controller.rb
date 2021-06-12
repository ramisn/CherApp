# frozen_string_literal: true

class FriendRequestsController < AuthenticationsController
  # rubocop:disable Metrics/AbcSize
  def create
    service_response = SendFriendRequestService.new(current_user, friend_request_params).execute
    respond_to do |format|
      format.json do
        render json: { friend_request: service_response.friend_request, status: service_response.status, message: service_response.message }, status: service_response.status
      end
      format.html do
        flash[service_response.message_key] = service_response.message
        if service_response.success?
          SendFriendRequestNotificationJob.perform_later(service_response.friend_request)
          redirect_back fallback_location: root_path
        else
          redirect_to edit_profile_path(@current_user)
        end
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  def update
    friend_request = FriendRequest.find(params[:id])
    if friend_request.update(update_request_params)
      if friend_request.approved?
        MadeFriendTrackerJob.perform_later(friend_request)
        registry_friend_request_accepted(friend_request)
        flash[:notice] = t('flashes.friend_request.accepted')
      else
        flash[:notice] = t('flashes.friend_request.rejected')
      end
    else
      flash[:alert] = t('flashes.friend_request.update.alert')
    end
    redirect_to social_networks_path
  end

  def index
    @received_requests = FriendRequest.joins(:requester)
                                      .where(requestee: current_user, status: :pending)
    respond_to do |format|
      format.html
      format.json { render json: @received_requests, each_serializer: FriendsRequestsSerializer }
    end
  end

  private

  def friend_request_params
    params.require(:friend_request)
          .permit(:requestee_id, :status)
          .merge(requester_id: current_user.id)
  end

  def update_request_params
    params.require(:friend_request).permit(:status)
  end

  def registry_friend_request_accepted(friend_request)
    friend_request.create_activity(:accepted,
                                   owner: current_user,
                                   recipient: friend_request.requester)
  end
end
