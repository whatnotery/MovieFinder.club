class CreateFilms < ActiveRecord::Migration[7.0]
  def change
    create_table :films do |t|
      t.string :title
      t.string :year
      t.string :plot
      t.string :poster
      t.string :mdb_id

      t.timestamps
    end
  end
end
