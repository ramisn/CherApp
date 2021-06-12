# frozen_string_literal: true

class SaveUserResponsesService
  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(user, response_params)
    @user = user
    @response_params = response_params
  end

  def execute
    build_user_responses
    if @user.save
      OpenStruct.new(success?: true, user: @user, errors: nil)
    else
      OpenStruct.new(success?: false, user: nil, errors: @user.errors)
    end
  end

  private

  def build_user_responses
    @user.attributes = @response_params
    return unless @user.responses.size == LiveFactor.number_of_questions

    @user.score = @user.responses.map { |response| response.response * response.live_factor.weight }.sum
  end
end
