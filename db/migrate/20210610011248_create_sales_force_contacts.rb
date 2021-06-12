class CreateSalesForceContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :sales_force_contacts do |t|
      t.string :sf_id
      t.string :string
      t.string :email
      t.string :name
      t.string :phone_number
      t.string :provider

      t.timestamps
    end
  end
end
