class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :title
      t.string :image
      t.string :description

      t.timestamps
    end
  end
end
