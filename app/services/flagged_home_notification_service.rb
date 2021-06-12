# frozen_string_literal: true

class FlaggedHomeNotificationService
  def initialize(user, property_address)
    full_address = property_address['full']
    city = property_address['city']
    state = property_address['state']
    @user = user
    @friends = user.friends
    @address = "#{full_address} #{city}, #{state}"
  end

  def execute
    @friends.each do |friend|
      next unless friend.accept_notification?(type: :flagged_home, method: :email)

      UserAccountMailer.with(user: @user, recipient: friend, address: @address).flagged_home_by_friend.deliver_later
    end
  end
end
