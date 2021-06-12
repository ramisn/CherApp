# frozen_string_literal: true

class ChangeParametersToJson < ActiveRecord::Migration[6.0]
  def change
    change_column :activities, :parameters, :jsonb, using: 'parameters::text::jsonb'
  end
end
