# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/activity_mailer
class ActivityMailerPreview < ActionMailer::Preview
  def newsletter_subscribe
    ActivityMailer.newsletter_subscribe('miguel@cher.app')
  end

  def property_share
    ActivityMailer.share_property({ recipient: 'miguel@cher.app',
                                    link: 'https://cher.app/properties/asdf123',
                                    body: 'Take a look at this',
                                    address: '123 Main street, Santa monica, CA 21331',
                                    user_name: 'Miguel Alvarado' }, co_borrower)
  end

  def share_post
    ActivityMailer.share_post({ recipient: 'miguel@cher.app', link: 'https://cher.app/activities/12', body: 'Take a look at this' }, co_borrower)
  end

  def share_review
    ActivityMailer.share_review({ recipient: 'miguel@cher.app', body: 'Review my work' }, agent)
  end

  def share_video
    ActivityMailer.share_video({ recipient: 'miguel@cher.app', link: 'https://cher.app', body: "Take a look at Cher's video", user_name: 'Miguel Aguilar' }, co_borrower)
  end

  def weekly_properties_drip
    user = co_borrower
    ActivityMailer.weekly_properties_drip(top_properties(user), user)
  end

  def weekly_leads_drip
    user = agent
    drip_data = FetchWeeklyLeadsDataService.new(user).execute
    ActivityMailer.weekly_leads_drip(drip_data, user)
  end

  def share_new_chat_message
    ActivityMailer.share_new_chat_message({ recipient_name: 'Gerald Amezcua', recipient: 'miguel@cher.app',
                                            link: 'https://cher.app/conversation/123', user_name: 'Miguel Aguilar' }, co_borrower)
  end

  def new_agent_lead_credit
    ActivityMailer.new_agent_lead_credit(agent_email: agent.email, user_email: co_borrower.email, date: DateTime.current)
  end

  def notify_contacted_lead
    ActivityMailer.notify_contacted_lead(co_borrower.email)
  end

  private

  def co_borrower
    User.new(email: 'miguel@cher.app', password: 'Password1', role: :co_borrower, first_name: 'Miguel', city: 'Santa Monica')
  end

  def agent
    User.new(email: 'sergio@cher.app', password: 'Password1', role: :agent, first_name: 'Sergio', plan_type: 'lite', id: 1, slug: 'sergio-agent-cher-app', areas: ['Santa Monica'])
  end

  def top_properties(user)
    TopPropertiesService.new(user).execute
  end
end
