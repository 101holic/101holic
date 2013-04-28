class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.string :url
      t.text :description
      t.references :user, index: true

      t.timestamps
    end
  end
end
