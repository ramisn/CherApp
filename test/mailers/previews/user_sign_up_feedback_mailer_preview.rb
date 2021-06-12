# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_account_mailer
class UserSignUpFeedbackMailerPreview < ActionMailer::Preview
  def first_ask
    UserSignUpFeedbackMailer.with(user: new_co_borrower).first_ask
  end

  def first_follow_up
    UserSignUpFeedbackMailer.with(user: new_co_borrower).first_follow_up
  end

  def second_follow_up
    UserSignUpFeedbackMailer.with(user: new_co_borrower).second_follow_up
  end

  def gift_card
    UserSignUpFeedbackMailer.with(user: new_co_borrower).gift_card
  end

  def last_round
    UserSignUpFeedbackMailer.with(user: new_co_borrower).last_round
  end

  private

  def new_co_borrower
    co_borrower = User.new(email: 'miguel@cher.app', password: 'Password1', role: :co_borrower, first_name: 'Miguel')
    co_borrower.build_notification_settings
    co_borrower
  end
end
