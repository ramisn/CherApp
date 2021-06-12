# frozen_string_literal: true

class UsersFinderService
  def initialize(search_users_params, current_user)
    @current_user = current_user
    @search_user_params = search_users_params
    @limit = @search_user_params[:limit] || 5
  end

  def execute
    users =  if @current_user&.agent?
               find_for_agent
             elsif @current_user
               find_for_coowner
             else
               []
             end
    users = users.where.not(email: @current_user.email) if exclude_current?
    users += suggested_users if include_prospects?
    users.first(@limit)
  end

  private

  def filtered_users(users)
    users = users.with_id_validation unless @search_user_params[:verified].blank?
    users = users.with_background_checked unless @search_user_params[:background_check].blank?
    users = users.select(&:test_finished?) unless @search_user_params[:personality_test].blank?
    users
  end

  def find_for_agent
    users = User.with_name.with_role(:agent).find_first_five_matches(@current_user.id, @search_user_params[:identifier])
    users = users.where(professional_role: @search_user_params[:professional_role]) unless @search_user_params[:professional_role].blank?
    users
  end

  def find_for_coowner
    users = User.kept.with_name.find_first_five_matches(@current_user.id, @search_user_params[:identifier])
    filtered_users(users)
  end

  def suggested_users
    User.by_search(@search_user_params[:suggestion]).with_name | Prospect.by_search(@search_user_params[:suggestion]).with_name
  end

  def include_prospects?
    @search_user_params[:suggestion] && !@search_user_params[:suggestion].blank?
  end

  def exclude_current?
    @search_user_params[:exclude_current]
  end
end
