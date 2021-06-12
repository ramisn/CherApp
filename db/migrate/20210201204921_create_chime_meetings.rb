# frozen_string_literal: true

class CreateChimeMeetings < ActiveRecord::Migration[6.0]
  def change
    create_table :chime_meetings do |t|
      t.string :meeting_id, null: false
      t.string :external_meeting_id, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
