# frozen_string_literal: true
# == Schema Information
#
# Table name: posts
#
#  id            :integer          not null, primary key
#  uuid          :uuid             not null
#  title         :string
#  feature_image :string
#  plaintext     :string
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# frozen_string_literal: true

class Post < ApplicationRecord
  include PublicActivity::Model
end
