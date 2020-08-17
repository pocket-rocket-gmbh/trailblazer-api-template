class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.integer :status
      t.string :email

      t.timestamps
    end
  end
end
