class AddMdbIdToLikes < ActiveRecord::Migration[7.0]
  def change
    add_column :likes, :mdb_id, :integer
  end
end
