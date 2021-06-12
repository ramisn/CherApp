# frozen_string_literal: true

class ContactSupportsController < ApplicationController
  def create
    ContactRequestMailer.notify_cher(contact_params).deliver_later
    MixpanelTracker.track_event(contact_params[:email], 'Requested demo') unless contact_params[:track_demo].blank?
    flash[:notice] = t('flashes.contacts.create.success')

    redirect_back fallback_location: root_path
  end

  private

  def contact_params
    params.require(:contact)
          .permit(:name, :email, :phone, :city, :state, :track_demo)
  end
end
