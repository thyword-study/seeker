class CreateBibleSectionSegmentAssociations < ActiveRecord::Migration[8.0]
  def change
    create_table :bible_section_segment_associations do |t|
      t.references :section, null: false, foreign_key: { on_delete: :cascade, to_table: :bible_sections }
      t.references :segment, null: false, foreign_key: { on_delete: :cascade, to_table: :bible_segments }

      t.timestamps
    end
  end
end
