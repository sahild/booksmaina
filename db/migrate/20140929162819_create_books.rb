class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.float :price
      t.string :genre
      t.string :description
      t.string :publisher
      t.integer :published_year

      t.timestamps
    end
  end
end
