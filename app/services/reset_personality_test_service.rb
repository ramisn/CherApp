# frozen_string_literal: true

class ResetPersonalityTestService
  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(user)
    @user = user
  end

  def execute
    update_user_attributes
    if @user.save
      OpenStruct.new(success?: true, user: @user, errors: nil)
    else
      OpenStruct.new(success?: false, user: @user, errors: @user.errors)
    end
  end

  private

  def update_user_attributes
    if @user.test_reset_period > Date.today + 6.months
      @user.test_attempts = 1
      @user.test_reset_period = Date.today
    elsif @user.test_attempts == 2
      block_user_test
    else
      @user.test_attempts += 1
    end
    @user.responses.each(&:mark_for_destruction)
    @user.last_question_reponded = nil
    @user.score = nil
  end

  def block_user_test
    @user.test_attempts = 0
    @user.test_blocked_till = Date.today + 1.month
    @user.verification_type = nil
    @user.needs_verification = true
  end
end
