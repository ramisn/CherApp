# frozen_string_literal: true

# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  body       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  test 'topic is not valid with no name' do
    topic = Topic.new(body: 'Topic body')

    refute topic.valid?
  end

  test 'topic is not valid with no body' do
    topic = Topic.new(name: 'What a co-bo is')

    refute topic.valid?
  end

  test 'topic is valid with name and body' do
    topic = Topic.new(name: 'What a co-bo is', rich_body: '<div>The topic body</div>')

    assert topic.valid?
  end

  test 'body field is auto-populated when savig record' do
    topic = Topic.create(name: 'What a co-bo is', rich_body: '<div>The topic body</div>')

    assert_equal topic.body, 'The topic body'
  end
end
