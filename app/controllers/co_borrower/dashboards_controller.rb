# frozen_string_literal: true

module CoBorrower
  class DashboardsController < BaseController
    def show
      @user_serialized = UsersSerializer.new(current_user, scope: current_user).as_json
      @flagged_properties = flagged_properties
      @like = Like.new
      @publication = Publication.new
      @comment = Comment.new
      @posts = FindLastNewsfeedPosts.new(current_user).execute
      @notifications = current_user.last_notifications
      @suggested_properties = suggested_properties
    end

    private

    def suggested_properties
      TopPropertiesService.new(current_user, 3, suggested: true).execute.values.flatten
    end

    def flagged_properties
      Kaminari.paginate_array(current_user.flagged_properties_data)
              .page(params[:page])
              .per(6)
    end
  end
end
