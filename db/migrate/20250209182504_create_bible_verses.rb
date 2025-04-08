class CreateBibleVerses < ActiveRecord::Migration[8.0]
  def change
    create_table :bible_verses do |t|
      t.references :translation, null: false, foreign_key: { on_delete: :restrict, to_table: :bible_translations }
      t.references :book, null: false, foreign_key: { on_delete: :restrict, to_table: :bible_books }
      t.references :chapter, null: false, foreign_key: { on_delete: :restrict, to_table: :bible_chapters }
      t.integer :number, null: false

      t.timestamps
    end

    add_index :bible_verses, [ :translation_id, :book_id, :chapter_id, :number ], unique: true
  end
end
