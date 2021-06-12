# frozen_string_literal: true

class AddLastQuestionRespondedToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :last_question_reponded, :string
  end
end
