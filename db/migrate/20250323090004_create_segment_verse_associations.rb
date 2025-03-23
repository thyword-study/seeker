class CreateSegmentVerseAssociations < ActiveRecord::Migration[8.0]
  def change
    create_table :segment_verse_associations do |t|
      t.references :segment, null: false, foreign_key: { on_delete: :cascade }
      t.references :verse, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
