# frozen_string_literal: true

class FindFriendLastNewsfeedPosts
  def initialize(user)
    @user = user
  end

  def execute
    (user_newsfeed_activities + user_newsfeed_publications).sort_by(&:created_at)
                                                           .reverse
                                                           .first(50)
  end

  private

  def user_newsfeed_publications
    Publication.user_updates(@user)
               .includes(:comments)
               .with_attached_images
  end

  def user_newsfeed_activities
    Activity.where("created_at > :user_join_cher_date
                  AND (owner_id = :user_id OR trackable_type = 'Post'
                  OR recipient_id = :user_id)",
                   user_id: @user.id,
                   user_join_cher_date: @user.created_at)
            .order(created_at: :desc)
            .includes(:comments)
            .limit(50)
  end
end
