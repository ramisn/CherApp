# frozen_string_literal: true

class MatchesController < AuthenticationsController
  def index
    @suggested_matches = suggested_matches
    respond_to do |format|
      format.html
      format.json { render json: @suggested_matches, each_serializer: UsersSerializer }
    end
  end
end
