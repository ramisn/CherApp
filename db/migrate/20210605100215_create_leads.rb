class CreateLeads < ActiveRecord::Migration[6.0]
  def change
    create_table :leads do |t|
      t.string :salesforce_id
      t.integer :status
      t.integer :user_id

      t.timestamps
    end
  end
end
