class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.integer :organization_id
      t.string :firstname
      t.string :lastname
      t.string :email
      t.integer :role
      t.integer :status
      t.text :jwt_token
      t.string :password_digest

      t.timestamps
    end
  end
end
