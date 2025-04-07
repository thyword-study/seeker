class CreateExpositionKeyThemes < ActiveRecord::Migration[8.0]
  def change
    create_table :exposition_key_themes do |t|
      t.references :content, null: false, foreign_key: { on_delete: :cascade, to_table: :exposition_contents }
      t.string :theme, null: false
      t.text :description, null: false

      t.timestamps
    end
  end
end
