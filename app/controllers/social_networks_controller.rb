# frozen_string_literal: true

class SocialNetworksController < AuthenticationsController
  before_action :check_city, only: [:index]
  def index
    @suggested_matches = suggested_matches
    @friend_requests = FriendRequest.user_pending_requests(current_user.id)
    @friends = current_user.friends
    @agents = User.kept.agent.by_area(current_user.city).order("end_of_clique IS NULL, end_of_clique DESC") if current_user.co_borrower?
    return unless params[:user]

    search_users
  end

  private

  def search_user_params
    params.require(:user)
          .permit(:identifier,
                  :verified,
                  :personality_test,
                  :background_check,
                  :limit)
  end

  def search_users
    @users = UsersFinderService.new(search_user_params, current_user).execute
    @search_for = search_user_params[:identifier]
    return if @users.any?

    @suggested_matches = suggested_matches
    @receiver = @search_for.match('^[_a-z0-9-]+(.[_a-z0-9-]+)*@[a-z0-9-]+(.[a-z0-9-]+)*(.[a-z]{2,4})')
    flash[:alert] = t('flashes.multisearch.error', search: @search_for)
  end

  def check_city
    if current_user.city.blank?
      flash[:alert] = t('notifications.complete_profile_city')
      redirect_to edit_profile_path(@current_user)
    end
  end
end
