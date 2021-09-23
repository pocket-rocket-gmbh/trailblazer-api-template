class CreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers do |t|
      t.string :code
      t.string :company_name
      t.string :street
      t.string :zip
      t.string :city
      t.string :phone
      t.string :fax
      t.string :contact_person
      t.string :contact_person_position
      t.string :email
      t.integer :organization_id

      t.timestamps
    end
  end
end
