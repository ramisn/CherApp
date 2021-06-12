# frozen_string_literal: true

class RobotsController < ApplicationController
  def show
    render 'robots.txt'
  end
end
