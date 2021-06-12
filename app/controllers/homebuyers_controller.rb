# frozen_string_literal: true

class HomebuyersController < ApplicationController
  def index
    @homebuyers = if user_signed_in? && current_user.agent?
                    User.with_role(:agent)
                        .with_name
                        .order('RANDOM()')
                        .limit(5)
                  else
                    HomebuyersFinderService.new(params[:property_id], sanitized_city, current_user&.id).execute
                  end
    render layout: false
  end

  private

  def sanitized_city
    params[:city].sub(/, .., USA/, '').downcase
  end
end
