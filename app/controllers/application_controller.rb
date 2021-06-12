# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include PublicActivity::StoreController
  include StorageLocationBackport

  before_action :store_user_location!, if: :storable_location?
  before_action :set_raven_context

  private

  def set_raven_context
    Raven.user_context(id: current_user.id) if current_user
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def suggested_matches
    if current_user.agent?
      User.with_role(:agent).suggested_matches_agent(current_user)

    else
      User.suggested_matches(current_user)
    end
  end
end
