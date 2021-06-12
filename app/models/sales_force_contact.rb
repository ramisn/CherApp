class SalesForceContact < ApplicationRecord
	has_one :contact, as: :contactable, dependent: :destroy
end
