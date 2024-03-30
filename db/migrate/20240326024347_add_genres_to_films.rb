class AddGenresToFilms < ActiveRecord::Migration[7.0]
  def change
    add_column :films, :genres, :string, array: true, default: []
  end
end
