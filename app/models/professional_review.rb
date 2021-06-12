# frozen_string_literal: true

class ProfessionalReview < ApplicationRecord
  belongs_to :reviewer, class_name: 'User', foreign_key: 'reviewer_id'
  belongs_to :reviewed, class_name: 'User', foreign_key: 'reviewed_id'

  validates :local_knowledge, :process_expertise, :responsiveness, :negotiation_skills, inclusion: 0..5
  validate :reviewer_is_valid?

  def reviewer_is_valid?
    return unless reviewed_id == reviewer_id

    errors.add :reviewer, I18n.t('flashes.reviews.create.same_person_reviewing')
  end
end
