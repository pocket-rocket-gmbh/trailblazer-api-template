class AddAddressFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :city, :string
    add_column :users, :zip_code, :string
    add_column :users, :country, :string
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
  end
end
