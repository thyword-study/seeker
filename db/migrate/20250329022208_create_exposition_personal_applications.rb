class CreateExpositionPersonalApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :exposition_personal_applications do |t|
      t.references :content, null: false, foreign_key: { on_delete: :cascade, to_table: :exposition_contents }
      t.string :title, null: false
      t.text :note, null: false

      t.timestamps
    end
  end
end
