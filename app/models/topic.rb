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

class Topic < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search_body, against: [:body]
  has_rich_text :rich_body
  before_validation :update_topic_plain_body
  validates_presence_of :name, :body
  scope :find_with_index, ->(index) { where('lower(name) like ? ', "#{index.downcase}%") }

  def update_topic_plain_body
    plaint_text_body = rich_body.to_plain_text
    self.body = plaint_text_body
  end
end
