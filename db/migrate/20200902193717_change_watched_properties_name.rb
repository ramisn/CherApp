# frozen_string_literal: true

class ChangeWatchedPropertiesName < ActiveRecord::Migration[6.0]
  def up
    rename_table :watched_properties, :flagged_properties
    Activity.where(trackable_type: 'WatchedProperty').update_all(trackable_type: 'FlaggedProperty')
    Activity.where(key: 'watched_property.destroy').update_all(key: 'flagged_property.destroy')
    Activity.where(key: 'watched_property.create').update_all(key: 'flagged_property.create')
  end

  def down
    rename_table :flagged_properties, :watched_properties
    Activity.where(trackable_type: 'FlaggedProperty').update_all(trackable_type: 'WatchedProperty')
    Activity.where(key: 'flagged_property.destroy').update_all(key: 'watched_property.destroy')
    Activity.where(key: 'flagged_property.create').update_all(key: 'watched_property.create')
  end
end
