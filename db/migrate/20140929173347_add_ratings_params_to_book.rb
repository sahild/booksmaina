class AddRatingsParamsToBook < ActiveRecord::Migration
  def change
    add_column :books, :rating, :float
  end
end
