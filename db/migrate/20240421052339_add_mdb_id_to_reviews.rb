class AddMdbIdToReviews < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :mdb_id, :integer
  end
end
