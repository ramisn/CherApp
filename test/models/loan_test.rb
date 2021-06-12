# frozen_string_literal: true

# == Schema Information
#
# Table name: loans
#
#  id                :bigint           not null, primary key
#  user_id           :bigint
#  property_id       :string
#  property_street   :string
#  property_city     :string
#  property_state    :string
#  property_zipcode  :string
#  property_county   :string
#  property_type     :string
#  property_occupied :string
#  first_home        :boolean          not null
#  live_there        :boolean          not null
#  status            :integer          default("0"), not null
#  unique_code       :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require 'test_helper'

class LoanTest < ActiveSupport::TestCase
  test 'it is not valid without a user' do
    loan = Loan.new(property_street: '123 Main street', first_home: true, live_there: true)

    refute loan.valid?
    assert loan.errors[:user].any?
  end

  test 'it is not valid without first_home' do
    co_borrower = users(:co_borrower_user)
    loan = Loan.new(user: co_borrower, property_street: '123 Main street', live_there: true)

    refute loan.valid?
    assert loan.errors[:first_home].any?
  end

  test 'it is not valid without live_there' do
    co_borrower = users(:co_borrower_user)
    loan = Loan.new(user: co_borrower, property_street: '123 Main street', first_home: true)

    refute loan.valid?
    assert loan.errors[:live_there].any?
  end

  test 'it is not valid without property street' do
    co_borrower = users(:co_borrower_user)
    loan = Loan.new(user: co_borrower, live_there: true, first_home: true)

    refute loan.valid?
    assert loan.errors[:property_street].any?
  end

  test 'it is valid with all attributes' do
    co_borrower = users(:co_borrower_user)
    loan = Loan.new(user: co_borrower, live_there: true, first_home: true, property_street: '123 Main Street')

    assert loan.valid?
  end
end
