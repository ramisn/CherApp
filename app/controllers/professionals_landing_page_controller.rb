# frozen_string_literal: true

class ProfessionalsLandingPageController < ApplicationController
  layout 'landing_page/application'

  def show
    @posts = GhostBlog.last_3_posts
    @new_user = User.new
  end
end
