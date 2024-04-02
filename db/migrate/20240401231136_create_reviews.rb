class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :film, null: false, foreign_key: true
      t.string :title
      t.integer :rating
      t.text :body

      t.timestamps
    end
  end
end
