class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.references :bible, null: false, foreign_key: { on_delete: :restrict }
      t.string :title, null: false
      t.integer :number, null: false
      t.string :code, null: false, limit: 3
      t.string :slug, null: false
      t.string :testament, null: false

      t.timestamps
    end

    add_index :books, [ :bible_id, :code ], unique: true
  end
end
