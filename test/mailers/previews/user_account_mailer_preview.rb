# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_account_mailer
class UserAccountMailerPreview < ActionMailer::Preview
  def background_check_approved
    UserAccountMailer.with(user: co_borrower).background_check_approved
  end

  def background_check_denied
    UserAccountMailer.with(user: co_borrower).background_check_denied
  end

  def clique_about_to_end
    UserAccountMailer.with(user: agent, last4: '4242').clique_about_to_end
  end

  def clique_payment_success
    UserAccountMailer.with(user: agent).clique_payment_success
  end

  def delete_account
    UserAccountMailer.with(user: co_borrower).delete_account
  end

  def flagged_home_by_friend
    UserAccountMailer.with(user: co_borrower, recipient: co_borrower, address: '123 Main street, Santa Monica, CA').flagged_home_by_friend
  end

  def friend_request
    UserAccountMailer.with(user: agent, requestee: co_borrower).friend_request
  end

  def listing_rental
    UserAccountMailer.with(user: co_borrower).listing_rental
  end

  private

  def co_borrower
    co_borrower = User.new(email: 'miguel@cher.app', password: 'Password1', role: :co_borrower, first_name: 'Miguel', last_name: 'Alvarado')
    co_borrower.build_notification_settings
    co_borrower
  end

  def agent
    agent = User.new(email: 'sergio@cher.app', password: 'Password1', role: :agent, first_name: 'Sergio', plan_type: 'lite', end_of_clique: Date.today + 3.days, id: 1)
    agent.build_notification_settings
    agent
  end
end
