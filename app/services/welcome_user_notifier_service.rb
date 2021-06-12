# frozen_string_literal: true

class WelcomeUserNotifierService
  def initialize(user)
    @user = user
  end

  def execute
    UsersMailer.send("welcome_#{@user.role}", @user).deliver_later
    NewUserMailer.notify_cher(new_user_params).deliver_later if @user.agent?
    GoogleAnalytics.track_completed_profile(@user) if Rails.env.production?
  end

  private

  def new_user_params
    { first_name: @user.first_name, email: @user.email, agent: @user.agent?, city: @user.city }
  end
end
