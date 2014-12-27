class AddFbAppScopedLinkToUser < ActiveRecord::Migration
  def change
    add_column :users, :fbAppScopedLink, :string
  end
end
