class CreateExpositionContents < ActiveRecord::Migration[8.0]
  def change
    create_table :exposition_contents do |t|
      t.references :section, null: false, foreign_key: { on_delete: :restrict, to_table: :bible_sections }
      t.text :summary, null: false
      t.text :context, null: false
      t.text :highlights, null: false, array: true, default: []
      t.text :reflections, null: false, array: true, default: []
      t.string :interpretation_type, null: false
      t.string :people, null: false, array: true, default: []
      t.string :places, null: false, array: true, default: []
      t.string :tags, null: false, array: true, default: []

      t.timestamps
    end

    add_index :exposition_contents, :highlights, using: :gin
    add_index :exposition_contents, :reflections, using: :gin
    add_index :exposition_contents, :people, using: :gin
    add_index :exposition_contents, :places, using: :gin
    add_index :exposition_contents, :tags, using: :gin
  end
end
