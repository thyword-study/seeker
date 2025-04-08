class CreateBibleSegmentVerseAssociations < ActiveRecord::Migration[8.0]
  def change
    create_table :bible_segment_verse_associations do |t|
      t.references :segment, null: false, foreign_key: { on_delete: :cascade, to_table: :bible_segments }
      t.references :verse, null: false, foreign_key: { on_delete: :cascade, to_table: :bible_verses }

      t.timestamps
    end
  end
end
