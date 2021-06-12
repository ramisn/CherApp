# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/users_mailer
class UsersMailerPreview < ActionMailer::Preview
  def confirmation
    UsersMailer.confirmation(agent, 'ewhwfvc243z')
  end

  def password_reset
    UsersMailer.password_reset(co_borrower, 'wey234n')
  end

  def referral
    referral = User.new(email: 'sergio@cher.app', password: 'Password1', role: :co_borrower)
    user = User.new(email: 'miguel@cher.app', password: 'Password1', role: :co_borrower, invited_by: referral)
    UsersMailer.referral(user, 'qwedj23')
  end

  def welcome_agent
    user = User.new(email: 'miguel@cher.app', password: 'Password1', role: :agent)
    UsersMailer.welcome_agent(user)
  end

  def welcome_co_borrower
    UsersMailer.welcome_co_borrower(co_borrower)
  end

  def notify_loan_invitation
    user = User.new(email: 'owner@cher.app', password: 'Password1', role: :co_borrower, first_name: 'Loan Requester')
    loan = Loan.new(id: 1, user: user, property_street: '123 Main Street', first_home: true, live_there: true, status: :active)
    participant = LoanParticipant.new(loan: loan, user: co_borrower, token: 'xqmnp9qwe32b-mn23o0ih2ce')
    UsersMailer.notify_loan_invitation(participant)
  end

  def notify_loan_completed
    UsersMailer.notify_loan_completed(co_borrower)
  end

  def notify_loan_owner
    UsersMailer.notify_loan_owner(co_borrower)
  end

  def notify_group_chat
    UsersMailer.notify_group_chat(co_borrower, co_borrower_2, '123asd')
  end

  def notify_property_changed
    UsersMailer.notify_property_changed(co_borrower)
  end

  private

  def co_borrower
    User.new(email: 'miguel@cher.app', password: 'Password1', role: :co_borrower, first_name: 'Miguel', last_name: 'Urbina')
  end

  def co_borrower_2
    User.new(email: 'gerald@cher.app', password: 'Password1', role: :co_borrower)
  end

  def agent
    User.new(email: 'salvador@cher.app', password: 'Password1', first_name: 'Salvador', role: :agent)
  end
end
