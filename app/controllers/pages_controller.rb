# frozen_string_literal: true

class PagesController < ApplicationController
  layout 'landing_page/application'

  def show
    if params['page'] == 'pricing' && !current_user&.agent?
      redirect_to root_path, alert: t('flashes.errors.access')
    else
      render params['page']
    end
  rescue ActionView::MissingTemplate
    render 'not_found.html'
  end
end
