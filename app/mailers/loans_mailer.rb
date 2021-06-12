# frozen_string_literal: true

class LoansMailer < ApplicationMailer
  def notify_admin_loan_ready(loan)
    @loan = loan
    mail to: [ENV['SUPPORT_MAIL'], ENV['SUPPORT_MAIL_2']], subject: 'A loan request is ready to be procesed'
  end
end
