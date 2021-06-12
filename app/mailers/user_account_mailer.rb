# frozen_string_literal: true

class UserAccountMailer < ApplicationMailer
  def background_check_approved
    @user = params[:user]
    return unless @user.accept_notification?(type: :background_check, method: :email)

    return if check_bounces(@user.email)

    mail to: @user.email, subject: 'Cher - Background Check Approved'
  end

  def background_check_denied
    user = params[:user]
    return unless user.accept_notification?(type: :background_check, method: :email)

    return if check_bounces(user.email)

    mail to: user.email, subject: 'Cher - Background Check Denied'
  end

  def clique_about_to_end
    @professional = params[:user]
    @card = params[:last4]
    return unless @professional.accept_notification?(type: :clique_expiration, method: :email)
    return unless @card

    return if check_bounces(@professional.email)

    mail to: @professional.email, subject: 'Your subscription will renew soon'
  end

  def clique_payment_success
    @professional = params[:user]
    return unless @professional.accept_notification?(type: :chers_clique, method: :email)

    return if check_bounces(@professional.email)

    mail to: @professional.email, subject: t("clique.payment_email_subject.#{@professional.plan_type}")
  end

  def delete_account
    @user = params[:user]
    return unless @user.accept_notification?(type: :delete_account, method: :email)

    return if check_bounces(@user.email)

    mail to: @user.email, subject: "Cher - We're Sad To See You Go"
  end

  def listing_rental
    @user = params[:user]
    return unless @user.accept_notification?(type: :listing, method: :email)

    return if check_bounces(@user.email)

    mail to: @user.email, subject: 'Listing Confirmation'
  end

  def flagged_home_by_friend
    @user = params[:user]
    @recipient = params[:recipient]
    @address = params[:address]
    return unless @recipient.accept_notification?(type: :flagged_home, method: :email)

    return if check_bounces(@user.email)

    mail to: @recipient.email, subject: 'A friend on Cher has flagged a home!'
  end

  def friend_request
    @requester = params[:user]
    @requestee = params[:requestee]
    return unless @requestee.accept_notification?(type: :friend_request, method: :email)

    return if check_bounces(@requester.email)

    mail to: @requestee.email, subject: 'Request to connect from user'
  end
end
