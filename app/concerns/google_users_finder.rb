# frozen_string_literal: true

class GoogleUsersFinder
  def find_users(emails, current_user)
    found_users = User.by_emails(emails).public_users(current_user.id).with_name
    users_email = User.all.pluck(:email)
    { users_in_cher: found_users, invitable_emails: emails - users_email }
  end
end
