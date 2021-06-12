# frozen_string_literal: true

class LoanParticipantsController < ApplicationController
  before_action :find_participant

  def edit
    @inviter = @loan_participant.loan.user
  end

  def update
    if @loan_participant.update(participant_params)
      update_loan_status
      flash[:notice] = t('flashes.loans.participants.notice')
    else
      flash[:alert] = t('flashes.loans.participants.alert')
    end
    redirect_to root_path
  end

  private

  def find_participant
    @loan_participant = LoanParticipant.find_by(token: params[:token])
    return redirect_to root_path unless @loan_participant
  end

  def participant_params
    params.require(:participant).permit(:accepted_request)
  end

  def update_loan_status
    loan = @loan_participant.loan
    return if loan.pending_participants?

    @loan_participant.loan.update!(status: :active)
  end
end
