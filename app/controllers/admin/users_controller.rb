# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    def update
      user = User.find_by(slug: params[:id])
      if user.update(user_params)
        flash[:notice] = 'User successfully updated'
      else
        flash[:alert] = 'Error updating user'
      end
      redirect_back fallback_location: admin_root_path
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name,
                                   :date_of_birth, :ssn,
                                   :phone_number)
    end
  end
end
