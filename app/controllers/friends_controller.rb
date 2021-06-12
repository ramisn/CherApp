# frozen_string_literal: true

class FriendsController < AuthenticationsController
  def index
    @friends = current_user.friends
    respond_to do |format|
      format.json do
        render json: @friends, each_serializer: UsersSerializer
      end
      format.html
    end
  end
end
