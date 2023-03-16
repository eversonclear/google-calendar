class AddGoogleTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :google_token, :string
    add_column :users, :google_refresh_token, :string
    add_column :users, :google_expire_token, :datetime
  end
end
