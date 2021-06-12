# frozen_string_literal: true

class ProfessionalContactsController < AuthenticationsController
  def create
    professionals = User.agent
                        .with_clique
                        .by_area(contact_params.dig(:area))

    ProfessionalContactService.new(current_user, professionals, contact_params).execute
    render json: :success
  end

  private

  def contact_params
    params.require(:professional_contact).permit(:name, :address, :area, :phone_number, :body, :contact_concierge)
  end
end
