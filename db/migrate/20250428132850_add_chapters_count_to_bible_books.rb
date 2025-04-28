class AddChaptersCountToBibleBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :bible_books, :chapters_count, :integer, default: 0, null: false
  end
end
