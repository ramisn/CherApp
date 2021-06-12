# frozen_string_literal: true

class FindLastNewsfeedPosts
  def initialize(user)
    @user = user
    @friedns = @user.friends
  end

  def execute
    (user_newsfeed_activities + user_newsfeed_publications).sort_by(&:created_at)
                                                           .reverse
                                                           .first(50)
  end

  private

  def user_newsfeed_publications
    Publication.latest_updates(@user)
               .includes(:comments)
               .with_attached_images
  end

  def user_newsfeed_activities
    Activity.where("created_at > :user_join_cher_date
                  AND (owner_id = :user_id OR trackable_type = 'Post'
                  OR recipient_id = :user_id
                  OR (owner_id IN (:friends_ids) AND trackable_type = 'FlaggedProperty'))",
                   user_id: @user.id,
                   friends_ids: @friends,
                   user_join_cher_date: @user.created_at)
            .order(created_at: :desc)
            .includes(:comments)
            .limit(50)
  end
end
