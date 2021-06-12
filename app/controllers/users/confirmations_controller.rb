# frozen_string_literal: true

module Users
  class ConfirmationsController < Devise::ConfirmationsController
    def show
      user = User.find_by(confirmation_token: params[:confirmation_token])
      token = user.send(:set_reset_password_token)
      redirect_to edit_password_path(user, reset_password_token: token)
    end
  end
end
