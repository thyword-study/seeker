class AddBooksCountToBibleTranslations < ActiveRecord::Migration[8.0]
  def change
    add_column :bible_translations, :books_count, :integer, default: 0, null: false
  end
end
