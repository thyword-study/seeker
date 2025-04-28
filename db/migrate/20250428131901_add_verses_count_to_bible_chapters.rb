class AddVersesCountToBibleChapters < ActiveRecord::Migration[8.0]
  def change
    add_column :bible_chapters, :verses_count, :integer, default: 0, null: false
  end
end
