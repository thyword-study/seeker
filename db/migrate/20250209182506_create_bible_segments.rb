class CreateBibleSegments < ActiveRecord::Migration[8.0]
  def change
    create_table :bible_segments do |t|
      t.references :translation, null: false, foreign_key: { on_delete: :restrict, to_table: :bible_translations }
      t.references :book, null: false, foreign_key: { on_delete: :restrict, to_table: :bible_books }
      t.references :chapter, null: false, foreign_key: { on_delete: :restrict, to_table: :bible_chapters }
      t.references :heading, null: false, foreign_key: { on_delete: :restrict, to_table: :bible_headings }
      t.integer :usx_position, null: false
      t.string :usx_style, null: false

      t.timestamps
    end
  end
end
