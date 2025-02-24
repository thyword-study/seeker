class CreateReferences < ActiveRecord::Migration[8.0]
  def change
    create_table :references do |t|
      t.references :bible, null: false, foreign_key: { on_delete: :restrict }
      t.references :book, null: false, foreign_key: { on_delete: :restrict }
      t.references :chapter, null: false, foreign_key: { on_delete: :restrict }
      t.references :heading, null: true, foreign_key: { on_delete: :restrict }
      t.string :target, null: false

      t.timestamps
    end
  end
end
