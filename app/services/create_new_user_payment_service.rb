# frozen_string_literal: true

class CreateNewUserPaymentService
  def initialize(params, cookies, request)
    @params = params
    @cookies = cookies
    @request = request
  end

  def execute
    generate_response(create_user)
  end

  private

  def generate_response(user)
    return { success: false } unless user

    CreatePaymentService.new(@params, user).execute.merge(user: user)
  end

  def create_user
    user = User.new(user_params)

    return unless user.save

    setup_registration(user)
    user
  end

  def setup_registration(user)
    return unless user

    user.send_confirmation_instructions
    mixpanel_key = @cookies.to_h.keys.grep(/mp_.*_mixpanel/)&.first
    mixpanel_data = mixpanel_key.blank? ? nil : JSON.parse(@cookies[mixpanel_key])
    mixpanel_data['$ip'] = @request.remote_ip unless mixpanel_data.blank?

    user.track_registration_event(mixpanel_data)
  end

  def user_params
    { first_name: @params[:first_name], last_name: @params[:last_name],
      email: @params[:email], role: :agent, confirmed_at: Time.now }
  end
end
