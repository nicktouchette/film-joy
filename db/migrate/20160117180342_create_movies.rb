class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title, null: false
      t.string :genre, null: false
      t.integer :year, null: false
      t.string :synopsis
      t.string :image
      t.integer :user_id, null: false
    end
  end
end
