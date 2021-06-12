# frozen_string_literal: true

class FacebookUsersFinder
  def find_users(identifiers, current_user)
    { users_in_cher: User.by_provider('facebook', identifiers)
                         .with_name
                         .public_users(current_user.id) }
  end
end
