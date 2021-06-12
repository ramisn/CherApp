# frozen_string_literal: true

class NotifyNewUserService
  def initialize(params)
    @params = params
  end

  def execute
    NewUserMailer.notify_cher(@params).deliver_later
    notify_agents
  end

  private

  def notify_agents
    professionals = User.agent
                        .with_clique
                        .by_area(@params[:city])

    professionals.each { |p| NewUserMailer.notify_agents(p, @params).deliver_later }
  end
end
