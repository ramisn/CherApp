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

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
