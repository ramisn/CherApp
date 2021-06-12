# frozen_string_literal: true

class UserSearchFinderService
  def initialize(search_params, user)
    @search_params = search_params
    @user = user
  end

  def execute
    @user.property_searches
         .with_statuses(@search_params[:status])
         .with_types(@search_params[:type])
         .find_by(sanitized_search_params)
  end

  private

  def sanitized_search_params
    @search_params.except(:lastId, :amount, :home_type,
                          :type, :status, :startdate,
                          :start_hour, :start_minute, :limit)
  end
end
