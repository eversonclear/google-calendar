class AddAzureDataToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :azure_token, :string
    add_column :users, :azure_refresh_token, :string
    add_column :users, :azure_expire_token, :datetime
  end
end
