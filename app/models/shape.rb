# frozen_string_literal: true

# == Schema Information
#
# Table name: shapes
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  shape_type  :integer          default("0"), not null
#  radius      :float            default("0.0")
#  center      :jsonb
#  coordinates :jsonb
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Shape < ApplicationRecord
  belongs_to :user

  enum shape_type: %i[polygon rectangle circle]

  validates_presence_of :name, :shape_type, :coordinates
  validate :validate_number_of_shapes_saved

  def validate_number_of_shapes_saved
    errors.add(:user, I18n.t('activerecord.errors.shapes.maximum_saved')) if user.shapes.count == 16
  end

  def points
    circle? ? center : coordinates
  end
end
