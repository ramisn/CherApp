# frozen_string_literal: true

module Admin
  class ProfessionalsController < BaseController
    def index
      @professionals = professionals
    end

    def update
      user = User.find_by(slug: params[:id])
      if user.update(proffesional_verfied: params[:proffesional_verfied])
        flash[:notice] = t('flashes.professional.update.notice')
      else
        flash[:alert] = t('flashes.professional.update.alert')
      end
      redirect_to admin_professionals_path
    end

    private

    def professionals
      professionals = case params[:filter]
                      when 'verified'
                        User.agent.where(proffesional_verfied: true)
                      when 'no_verified'
                        User.agent.where(proffesional_verfied: false)
                      else
                        User.agent
                      end

      professionals = professionals.by_search(params[:search]) if params[:search]

      professionals
    end
  end
end
