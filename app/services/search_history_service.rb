# frozen_string_literal: true

class SearchHistoryService
  def initialize(city, user)
    @city = city&.downcase
    @user = user
  end

  def save_history
    return if @city.blank? || search_history.include?(@city)

    @user.update(search_history: search_history << @city)
  end

  private

  def search_history
    @user.search_history
  end
end
