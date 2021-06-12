# frozen_string_literal: true

# == Schema Information
#
# Table name: publications
#
#  id               :bigint           not null, primary key
#  owner_id         :bigint
#  message          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  recipient_id     :bigint
#  publication_type :integer
#  link             :string
#  params           :jsonb
#
class Publication < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id', optional: true
  has_many_attached :images, dependent: :destroy
  has_many :comments, as: :post, dependent: :destroy
  has_many :likes, as: :post, dependent: :destroy

  validates :images, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 10.megabytes }
  validates :message, length: { minimum: 1 }
  validate :publication_owner

  scope :latest_updates, ->(user) { where(owner: user.friends).or(where(owner: user)).top_50 }
  scope :user_updates, ->(user) { where(owner: user).or(where(recipient: user)).top_50 }
  scope :top_50, -> { order(created_at: :desc).limit(50) }

  after_create :track_publication

  def publication_owner
    return unless owner == recipient

    errors.add :recipient, I18n.t('publication.errors.same_owner')
  end

  def track_publication
    return unless Rails.env.production? || Rails.env.staging?

    MixpanelTracker.track_event(owner.email, 'Create a publication', 'Images attached?': images.attached?)
  end
end
