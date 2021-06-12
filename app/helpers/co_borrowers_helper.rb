# frozen_string_literal: true

module CoBorrowersHelper
  def user_posible_fund(user)
    number_to_currency(user.funding * (user.co_borrowers || 1), precision: 0)
  end
end
