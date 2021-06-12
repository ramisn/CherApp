# frozen_string_literal: true

require 'test_helper'

class UsersMailerTest < ActionMailer::TestCase
  test 'it success sending notify cher email' do
    mail = NewUserMailer.notify_cher(params)

    assert_equal 'A new user joined Cher', mail.subject
    assert_equal ENV['NEW_USERS_RECEIVERS'].split(','), mail.to
    assert_equal ['cher@cher.app'], mail.from
    assert_match 'A new user joined Cher', mail.body.encoded
  end

  test 'it success sending notify agents email' do
    agent = User.new(email: 'salvador@cher.app', password: 'Password1', first_name: 'Salvador', role: :agent)
    mail = NewUserMailer.notify_agents(agent, params)

    assert_equal 'A new homebuyer just joined Cher!', mail.subject
    assert_equal [agent.email], mail.to
    assert_equal ['cher@cher.app'], mail.from
    assert_match "A new homebuyer just joined Cher! #{params[:first_name]} is interested in buying a home in #{params[:city]}. ", mail.body.encoded
  end

  private

  def params
    user = User.new(email: 'miguel@cher.app', password: 'Password1', role: :co_borrower, first_name: 'Miguel', last_name: 'Urbina', city: 'Santa Monica', slug: 'miguel-urbina')

    { first_name: user.first_name, email: user.email, agent: user.agent?, city: user.city, slug: user.slug }
  end
end
