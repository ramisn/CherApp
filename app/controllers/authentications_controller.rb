# frozen_string_literal: true

class AuthenticationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_last_seen_at, if: :user_signed_in?

  private

  def set_last_seen_at
    current_user.update(last_seen_at: Time.now)
  end
end
