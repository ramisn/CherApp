# frozen_string_literal: true

module Admin
  class CoBorrowersController < BaseController
    def index
      @users_who_requested = User.joins(:requested_loans)
                                 .includes(:requested_loans)
    end
  end
end
