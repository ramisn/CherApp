# frozen_string_literal: true

class HomebuyersFinderService
  def initialize(property_id, city, current_user_id, limit = 5)
    @property_id = property_id
    @city = city
    @current_user_id = current_user_id
    @limit = limit
  end

  def execute
    users_who_flagged_in_same_spot = FlaggedProperty.people_who_also_flagged(@property_id, @city, @current_user_id, @limit)
    users_who_flagged_in_same_spot + random_users(users_who_flagged_in_same_spot)
  end

  private

  def random_users(users_who_flagged_in_same_spot)
    users = User.public_users(@current_user_id)
                .with_name
                .not_in_collection(users_who_flagged_in_same_spot)

    return users unless @limit&.positive?

    users.limit(@limit - users_who_flagged_in_same_spot.size)
  end
end
