# frozen_string_literal: true

# == Schema Information
#
# Table name: houses
#
#  id                        :bigint           not null, primary key
#  owner_id                  :bigint           not null
#  address                   :string
#  state                     :string
#  county                    :string
#  price                     :integer
#  home_type                 :integer
#  beds                      :integer
#  full_baths                :integer
#  half_baths                :integer
#  interior_area             :decimal(, )
#  lot_size                  :decimal(, )
#  year_build                :integer
#  hoa_dues                  :decimal(, )
#  basement_area             :decimal(, )
#  garage_area               :decimal(, )
#  description               :text
#  details                   :text
#  date_for_open_house       :date
#  start_hour_for_open_house :time
#  end_hour_for_open_house   :time
#  website                   :string
#  phone_contact             :string
#  email_contact             :string
#  status                    :integer          default("0"), not null
#  accept_terms              :boolean
#  ownership_percentage      :decimal(, )
#  receive_analysis          :boolean          default("false"), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  selling_percentage        :integer          default("0"), not null
#  down_payment              :integer          default("0"), not null
#  monthly_mortgage          :integer          default("0"), not null
#  mlsid                     :string
#  draft                     :boolean          default("false")
#
class House < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_and_belongs_to_many :users
  has_many_attached :images

  enum status: %i[pending approved rejected]
  enum home_type: %i[residential condo mobile multifamily]

  validates :accept_terms, acceptance: true, unless: :draft
  validates :images, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 10.megabytes }, unless: :draft
  validates_presence_of :address, :state, :county, :price, :ownership_percentage,
                        :beds, :full_baths, :email_contact, :interior_area, :county,
                        :lot_size, :phone_contact, :home_type, :accept_terms, :selling_percentage,
                        :down_payment, :monthly_mortgage, unless: :draft

  scope :draft, -> { where(draft: true) }
end
