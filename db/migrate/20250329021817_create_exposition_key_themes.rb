class CreateExpositionKeyThemes < ActiveRecord::Migration[8.0]
  def change
    create_table :exposition_key_themes do |t|
      t.references :exposition_content, null: false, foreign_key: { on_delete: :cascade }
      t.string :theme, null: false
      t.string :description, null: false

      t.timestamps
    end
  end
end
