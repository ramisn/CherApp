# frozen_string_literal: true

class SendFriendRequestService
  def initialize(current_user, params)
    @current_user = current_user
    @friend_request = FriendRequest.new(params)
  end

  def execute
    if @current_user.profile_completed?
      if @friend_request.save
        OpenStruct.new(success?: true, status: 201, friend_request: @friend_request,
                       message: I18n.t('flashes.friend_request.create.notice'), message_key: :notice)
      else
        OpenStruct.new(success?: false, status: 406, friend_request: @friend_request.errors,
                       message: I18n.t('flashes.friend_request.create.alert'), message_key: :alert)
      end
    else
      OpenStruct.new(success?: false, status: 302, friend_request: @friend_request,
                     message: I18n.t('users.errors.need_to_complete_profile'), message_key: :alert)
    end
  end
end
