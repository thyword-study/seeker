class CreateExpositionAnalyses < ActiveRecord::Migration[8.0]
  def change
    create_table :exposition_analyses do |t|
      t.references :exposition_content, null: false, foreign_key: { on_delete: :cascade }
      t.text :part, null: false
      t.text :note, null: false
      t.integer :position, null: false

      t.timestamps
    end
  end
end
