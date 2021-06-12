# frozen_string_literal: true

class CreateUserFromOmniauthService
  def self.call(user_data, omniauth_params, search_intent)
    new(user_data, omniauth_params, search_intent).execute
  end

  def initialize(auth, omniauth_params, search_intent)
    @auth = auth
    @search_intent = search_intent
    @referral_code = omniauth_params['referral_code']
    @role = omniauth_params['role']
    @professional_role = omniauth_params['professional_role']
    @accept_referral_agreement = omniauth_params['accept_referral_agreement']
  end

  def execute
    user = find_or_create_user
    if user.persisted?
      user.update(image: safety_image_url) unless @new_record

      OpenStruct.new(success?: true, user: user, errors: nil)
    else
      OpenStruct.new(success?: false, user: nil, errors: user.errors)
    end
  end

  private

  def find_or_create_user
    referral_user_id = User.find_by(referral_code: @referral_code)&.id
    User.where(email: @auth.dig('info', 'email')).first_or_create do |new_user|
      @new_record = true
      build_user(new_user, referral_user_id)
    end
  end

  def build_user(user, referral_user_id)
    user.email = @auth.dig('info', 'email')
    user.password = Devise.friendly_token[0, 20]
    user.first_name = @auth.dig('info', 'first_name') || user_first_name
    user.last_name = @auth.dig('info', 'last_name') || user_last_name
    user.image = safety_image_url
    user.blurred_image.attach(io: blurred_image(user), filename: 'blurred_image.jpg', content_type: 'image/jpg')
    user.confirmed_at = Time.now
    user.uid = @auth.dig('uid')
    user.provider = @auth.dig('provider')
    user.search_intent = @search_intent
    user.invited_by_id = referral_user_id
    user.skip_mailchimp_verification = true
    user.role = @role
    user.professional_role = @professional_role
    user.accept_referral_agreement = @accept_referral_agreement
  end

  def user_first_name
    full_name = @auth.dig('info', 'name')
    last_name = full_name.split(' ').last
    full_name.gsub(last_name, '')
  end

  def user_last_name
    @auth.dig('info', 'name').split(' ').last
  end

  def blurred_image(user)
    BlurImageService.new(user.image).blur_image || File.open('app/assets/images/cherapp-ownership-coborrowing-person.png')
  end

  def safety_image_url
    image_url = @auth.dig('info', 'image') || @auth.dig('info', 'picture_url') || ''
    image_url.gsub('http://', 'https://')
  end
end
