# frozen_string_literal: true

class LandingPageController < ApplicationController
  layout 'landing_page/application'

  def show
    @posts = GhostBlog.last_3_posts
    @new_user = User.new
    @suggested_properties = LookAround::FindFeaturePropertiesService.new(current_user).execute[:properties].first(4)
  end
end
