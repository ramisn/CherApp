# frozen_string_literal: true

class SendWeeklyCustomerLeadsService
  def execute
    User.kept.agent.each { |user| send_email(user) }
  end

  private

  def send_email(user)
    data = FetchWeeklyLeadsDataService.new(user).execute

    ActivityMailer.weekly_leads_drip(data, user).deliver_now unless data.users_by_area.empty?
  end
end
