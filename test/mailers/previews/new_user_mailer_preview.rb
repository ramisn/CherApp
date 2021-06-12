# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/new_user_mailer
class NewUserMailerPreview < ActionMailer::Preview
  def notify_cher
    NewUserMailer.notify_cher(params)
  end

  def notify_agents
    NewUserMailer.notify_agents(agent, params)
  end

  private

  def params
    user = User.create(email: 'miguel@cher.app', password: 'Password1', role: :co_borrower, last_name: 'Urbina', city: 'Santa Monica', slug: 'miguel-urbina')

    { first_name: user.first_name, email: user.email, agent: user.agent?, city: user.city, slug: user.slug }
  end

  def agent
    User.new(email: 'salvador@cher.app', password: 'Password1', first_name: 'Salvador', role: :agent)
  end
end
