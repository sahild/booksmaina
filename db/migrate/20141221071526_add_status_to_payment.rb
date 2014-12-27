class AddStatusToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :status, :boolean
  end
end
