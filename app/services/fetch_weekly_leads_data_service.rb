# frozen_string_literal: true

class FetchWeeklyLeadsDataService
  def initialize(user, watched_properties_finder = FindMostWatchedPropertiesService)
    @user = user
    @watched_properties_finder = watched_properties_finder
  end

  def execute
    OpenStruct.new(users_by_area: users_hash, most_watched_property: most_watched_property) if @user.agent?
  end

  private

  def users_hash
    @user.areas.each_with_object({}) do |area, memo|
      users = users_by_area(area)
      memo[area] = { area: area, users: users } unless users.empty?
    end
  end

  def most_watched_property
    @watched_properties_finder.new(@user.areas, 1).most_watched_properties.first
  end

  def users_by_area(area)
    User.kept
        .co_borrower
        .created_from(1.year.ago)
        .by_city(area)
        .order(created_at: :desc)
        .first(8)
  end
end
