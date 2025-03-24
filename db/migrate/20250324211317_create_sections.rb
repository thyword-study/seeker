class CreateSections < ActiveRecord::Migration[8.0]
  def change
    create_table :sections do |t|
      t.references :bible, null: false, foreign_key: { on_delete: :restrict }
      t.references :book, null: false, foreign_key: { on_delete: :restrict }
      t.references :chapter, null: false, foreign_key: { on_delete: :restrict }
      t.references :heading, null: false, foreign_key: { on_delete: :restrict }
      t.integer :position, null: false

      t.timestamps
    end
  end
end
