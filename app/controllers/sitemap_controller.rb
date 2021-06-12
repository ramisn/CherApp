# frozen_string_literal: true

class SitemapController < ApplicationController
  def show
    render 'sitemap.xml'
  end
end
