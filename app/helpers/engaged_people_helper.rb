# frozen_string_literal: true

module EngagedPeopleHelper
  def engaged_person_picture(engaged_person)
    profile_picture(engaged_person) || blurred_image(engaged_person)
  end

  def profile_picture(engaged_person)
    return if !user_signed_in? ||
              !current_user.profile_fulfilled? ||
              !engaged_person.profile_fulfilled?

    engaged_person.profile_image
  end

  def blurred_image(engaged_person)
    engaged_person.blurred_image.present? ? engaged_person.blurred_image : 'cherapp-ownership-coborrowing-ico-user.svg'
  end
end
