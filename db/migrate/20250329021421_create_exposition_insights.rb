class CreateExpositionInsights < ActiveRecord::Migration[8.0]
  def change
    create_table :exposition_insights do |t|
      t.references :content, null: false, foreign_key: { on_delete: :cascade, to_table: :exposition_contents }
      t.string :kind, null: false
      t.text :note, null: false

      t.timestamps
    end
  end
end
