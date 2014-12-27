class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :amount

      t.timestamps
    end
  end
end
