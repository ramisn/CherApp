# frozen_string_literal: true

# == Schema Information
#
# Table name: loans
#
#  id                :bigint           not null, primary key
#  user_id           :bigint
#  property_id       :string
#  property_street   :string
#  property_city     :string
#  property_state    :string
#  property_zipcode  :string
#  property_county   :string
#  property_type     :string
#  property_occupied :string
#  first_home        :boolean          not null
#  live_there        :boolean          not null
#  status            :integer          default("0"), not null
#  unique_code       :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Loan < ApplicationRecord
  has_many :participants, class_name: 'LoanParticipant', dependent: :destroy
  belongs_to :user
  validates_presence_of :property_street
  validates_inclusion_of :first_home, in: [true, false]
  validates_inclusion_of :live_there, in: [true, false]
  validates_uniqueness_of :unique_code, allow_blank: true

  accepts_nested_attributes_for :participants
  enum status: %i[waiting active finished rejected]
  after_create :notify_participants, :updated_status

  def notify_participants
    UsersMailer.notify_loan_owner(user).deliver_later

    participants.each do |participant|
      UsersMailer.notify_loan_invitation(participant).deliver_later
    end
  end

  def pending_participants?
    participants.where(accepted_request: false).any?
  end

  def updated_status
    return if pending_participants?

    update!(status: :active)
    LoansMailer.notify_admin_loan_ready(self).deliver_now
  end
end
