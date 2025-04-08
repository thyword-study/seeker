class CreateBibleBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :bible_books do |t|
      t.references :translation, null: false, foreign_key: { on_delete: :restrict, to_table: :bible_translations }
      t.string :title, null: false
      t.integer :number, null: false
      t.string :code, null: false, limit: 3
      t.string :slug, null: false
      t.string :testament, null: false

      t.timestamps
    end

    add_index :bible_books, [ :translation_id, :code ], unique: true
  end
end
