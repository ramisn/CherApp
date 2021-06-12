# frozen_string_literal: true

module Admin
  class ProspectsController < BaseController
    before_action :already_subscribed?, only: %i[create]

    def new
      @prospect = Prospect.new
    end

    def create
      prospect = Prospect.new(prospect_params)
      if prospect.save
        flash[:notice] = 'Prospect successfully registered'
      else
        flash[:alert] = 'Error registering prospect'
      end
      redirect_to admin_contacts_path
    end

    private

    def already_subscribed?
      return unless Prospect.where(email: params[:prospect][:email]).exists?

      flash[:notice] = t('flashes.prospect.create.already_subscribed')
      redirect_to admin_contacts_path
    end

    def prospect_params
      params.require(:prospect)
            .permit(:email, :first_name, :last_name,
                    :city, :role, :is_subscribed,
                    :marked_as_spam, :phone_number)
    end
  end
end
