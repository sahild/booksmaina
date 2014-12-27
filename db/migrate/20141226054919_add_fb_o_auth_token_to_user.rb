class AddFbOAuthTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :fbOAuthToken, :string
  end
end
