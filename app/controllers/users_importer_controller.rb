# frozen_string_literal: true

class UsersImporterController < AuthenticationsController
  def new
    users_finder = UserFinderFactory.new(params[:social_network]).finder
    finder_response = users_finder.find_users(params[:identifiers], current_user)
    @users = no_friend_users(finder_response[:users_in_cher])
    @invitable_emails = finder_response[:invitable_emails]
    html_response = render_to_string('new.html.haml', layout: false)
    render json: { html: html_response }
  end

  def create
    respond_to do |format|
      format.json do
        params[:users].each do |user_id|
          FriendRequest.create!(requester_id: current_user.id, requestee_id: user_id)
        end
        render json: {}
      rescue StandardError => e
        render json: e, status: 500
      end
    end
  end

  private

  def no_friend_users(users)
    users.reject { |user| current_user.friends.include?(user) }
  end
end
