# frozen_string_literal: true

class AddPhoneNumberToProspect < ActiveRecord::Migration[6.0]
  def change
    change_table :prospects do |t|
      t.string :phone_number
      t.string :last_name
    end

    change_column_null :prospects, :email, true
  end
end
