# frozen_string_literal: true

module PagesHelper
  def start_path
    return new_registration_path(User) unless current_user
    return co_borrower_dashboard_path if current_user.co_borrower?
    return customer_dashboard_path if current_user.agent?
  end
end
