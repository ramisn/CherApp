# frozen_string_literal: true

# == Schema Information
#
# Table name: loan_participants
#
#  id               :bigint           not null, primary key
#  user_id          :bigint
#  loan_id          :bigint
#  accepted_request :boolean          default("false"), not null
#  token            :string
#
class LoanParticipant < ApplicationRecord
  belongs_to :loan, required: true
  belongs_to :user, required: true

  delegate :first_name, :last_name, :full_name, :email, to: :user

  before_create :setup_token
  after_update :update_loan_status

  def setup_token
    self.token = Devise.friendly_token(40)
  end

  def update_loan_status
    return if loan.pending_participants?

    loan.update!(status: :active)
    LoansMailer.notify_admin_loan_ready(loan).deliver_later
  end
end
