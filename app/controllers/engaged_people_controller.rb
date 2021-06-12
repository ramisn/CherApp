# frozen_string_literal: true

class EngagedPeopleController < ApplicationController
  def index
    @engaged_people = User.joins(:flagged_properties)
                          .where(flagged_properties: { property_id: params[:property_id] })
                          .where.not(id: current_user&.id)
                          .order(:email)
                          .uniq
    render layout: false
  end
end
