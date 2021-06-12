# frozen_string_literal: true

class PlacesAroundController < ApplicationController
  def show
    number_of_places = Places.number_of_places_by_type(params[:type], "#{params[:latitude]},#{params[:longitude]}")
    respond_to do |format|
      format.json { render json: number_of_places }
    end
  end
end
