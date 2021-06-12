# frozen_string_literal: true

class RenameSubscriberToProspect < ActiveRecord::Migration[6.0]
  def change
    rename_table :subscribers, :prospects
  end
end
