# frozen_string_literal: true

class ProfessionalContactCheckerService
  def initialize(requester, params)
    @requester = requester
    @params = params
  end

  def execute
    return if professional_accepted_request?(@requester)

    unacepted_channels = MessageChannel.where("participants @> ARRAY[?]::varchar[]
                                               AND purpose = 'professional_support'", @requester.email)
    new_professionals_batch = find_new_professionals_batch(unacepted_channels)
    update_unaccepted_channels(unacepted_channels)
    # EXIT WHEN NO MORE PROFESSIONALS LEFT
    return unless new_professionals_batch.any?

    ProfessionalContactService.new(@requester, new_professionals_batch, @params).execute
  end

  private

  def professional_accepted_request?(requester)
    !MessageChannel.where("participants @> ARRAY[?]::varchar[]
                           AND purpose = 'professional_support'
                           AND status = ?", requester.email, 0)
                   .exists?
  end

  def find_new_professionals_batch(unacepted_channels)
    professionals = unacepted_channels.map { |channel| channel.participants.second }
    new_professionals_batch = User.with_role(:agent)
                                  .with_clique
                                  .where.not(email: professionals)
                                  .limit(10)
    new_professionals_batch = User.with_role(:agent).where.not(email: professionals).limit(10) if new_professionals_batch.blank?
    new_professionals_batch.any? ? new_professionals_batch : User.where(email: ENV['ERIC_EMAIL'])
  end

  def update_unaccepted_channels(unacepted_channels)
    unacepted_channels.update_all(status: :closed)
  end
end
