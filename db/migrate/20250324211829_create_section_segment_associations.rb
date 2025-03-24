class CreateSectionSegmentAssociations < ActiveRecord::Migration[8.0]
  def change
    create_table :section_segment_associations do |t|
      t.references :section, null: false, foreign_key: { on_delete: :cascade }
      t.references :segment, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
