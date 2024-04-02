class AddUniqueIndexToFilmsMdbId < ActiveRecord::Migration[7.0]
  def change
    add_index :films, :mdb_id, unique: true
  end
end
