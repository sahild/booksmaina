class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.references :cart, index: true
      t.string :type
      t.float :discount
      t.string :promo_code
      t.float :orig_price
      t.float :discounted_price
      t.integer :count
      t.references :book, index: true

      t.timestamps
    end
  end
end
