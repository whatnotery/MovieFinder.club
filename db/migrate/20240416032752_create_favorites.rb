class CreateFavorites < ActiveRecord::Migration[7.0]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :film, null: false, foreign_key: true
      t.integer :mdb_id

      t.timestamps
    end
  end
end
