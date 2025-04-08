# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_02_11_205543) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bible_books", force: :cascade do |t|
    t.bigint "translation_id", null: false
    t.string "title", null: false
    t.integer "number", null: false
    t.string "code", limit: 3, null: false
    t.string "slug", null: false
    t.string "testament", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["translation_id", "code"], name: "index_bible_books_on_translation_id_and_code", unique: true
    t.index ["translation_id"], name: "index_bible_books_on_translation_id"
  end

  create_table "bible_chapters", force: :cascade do |t|
    t.bigint "translation_id", null: false
    t.bigint "book_id", null: false
    t.integer "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_bible_chapters_on_book_id"
    t.index ["translation_id", "book_id", "number"], name: "index_bible_chapters_on_translation_id_and_book_id_and_number", unique: true
    t.index ["translation_id"], name: "index_bible_chapters_on_translation_id"
  end

  create_table "bible_footnotes", force: :cascade do |t|
    t.bigint "translation_id", null: false
    t.bigint "book_id", null: false
    t.bigint "chapter_id", null: false
    t.bigint "verse_id"
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_bible_footnotes_on_book_id"
    t.index ["chapter_id"], name: "index_bible_footnotes_on_chapter_id"
    t.index ["translation_id"], name: "index_bible_footnotes_on_translation_id"
    t.index ["verse_id"], name: "index_bible_footnotes_on_verse_id"
  end

  create_table "bible_fragments", force: :cascade do |t|
    t.bigint "translation_id", null: false
    t.bigint "book_id", null: false
    t.bigint "chapter_id", null: false
    t.bigint "heading_id", null: false
    t.bigint "verse_id"
    t.bigint "segment_id", null: false
    t.boolean "show_verse", null: false
    t.string "kind", null: false
    t.text "content", null: false
    t.integer "position", null: false
    t.string "fragmentable_type"
    t.bigint "fragmentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_bible_fragments_on_book_id"
    t.index ["chapter_id"], name: "index_bible_fragments_on_chapter_id"
    t.index ["fragmentable_type", "fragmentable_id"], name: "index_bible_fragments_on_fragmentable"
    t.index ["heading_id"], name: "index_bible_fragments_on_heading_id"
    t.index ["segment_id"], name: "index_bible_fragments_on_segment_id"
    t.index ["translation_id"], name: "index_bible_fragments_on_translation_id"
    t.index ["verse_id"], name: "index_bible_fragments_on_verse_id"
  end

  create_table "bible_headings", force: :cascade do |t|
    t.bigint "translation_id", null: false
    t.bigint "book_id", null: false
    t.bigint "chapter_id", null: false
    t.string "kind", null: false
    t.integer "level", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_bible_headings_on_book_id"
    t.index ["chapter_id"], name: "index_bible_headings_on_chapter_id"
    t.index ["translation_id"], name: "index_bible_headings_on_translation_id"
  end

  create_table "bible_segments", force: :cascade do |t|
    t.bigint "translation_id", null: false
    t.bigint "book_id", null: false
    t.bigint "chapter_id", null: false
    t.bigint "heading_id", null: false
    t.integer "usx_position", null: false
    t.string "usx_style", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_bible_segments_on_book_id"
    t.index ["chapter_id"], name: "index_bible_segments_on_chapter_id"
    t.index ["heading_id"], name: "index_bible_segments_on_heading_id"
    t.index ["translation_id"], name: "index_bible_segments_on_translation_id"
  end

  create_table "bible_translations", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", limit: 3, null: false
    t.text "statement", null: false
    t.string "rights_holder_name", null: false
    t.string "rights_holder_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_bible_translations_on_code", unique: true
  end

  create_table "bible_verses", force: :cascade do |t|
    t.bigint "translation_id", null: false
    t.bigint "book_id", null: false
    t.bigint "chapter_id", null: false
    t.integer "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_bible_verses_on_book_id"
    t.index ["chapter_id"], name: "index_bible_verses_on_chapter_id"
    t.index ["translation_id", "book_id", "chapter_id", "number"], name: "idx_on_translation_id_book_id_chapter_id_number_3c298a7c72", unique: true
    t.index ["translation_id"], name: "index_bible_verses_on_translation_id"
  end

  add_foreign_key "bible_books", "bible_translations", column: "translation_id", on_delete: :restrict
  add_foreign_key "bible_chapters", "bible_books", column: "book_id", on_delete: :restrict
  add_foreign_key "bible_chapters", "bible_translations", column: "translation_id", on_delete: :restrict
  add_foreign_key "bible_footnotes", "bible_books", column: "book_id", on_delete: :restrict
  add_foreign_key "bible_footnotes", "bible_chapters", column: "chapter_id", on_delete: :restrict
  add_foreign_key "bible_footnotes", "bible_translations", column: "translation_id", on_delete: :restrict
  add_foreign_key "bible_footnotes", "bible_verses", column: "verse_id", on_delete: :restrict
  add_foreign_key "bible_fragments", "bible_books", column: "book_id", on_delete: :restrict
  add_foreign_key "bible_fragments", "bible_chapters", column: "chapter_id", on_delete: :restrict
  add_foreign_key "bible_fragments", "bible_headings", column: "heading_id", on_delete: :restrict
  add_foreign_key "bible_fragments", "bible_segments", column: "segment_id", on_delete: :restrict
  add_foreign_key "bible_fragments", "bible_translations", column: "translation_id", on_delete: :restrict
  add_foreign_key "bible_fragments", "bible_verses", column: "verse_id", on_delete: :restrict
  add_foreign_key "bible_headings", "bible_books", column: "book_id", on_delete: :restrict
  add_foreign_key "bible_headings", "bible_chapters", column: "chapter_id", on_delete: :restrict
  add_foreign_key "bible_headings", "bible_translations", column: "translation_id", on_delete: :restrict
  add_foreign_key "bible_segments", "bible_books", column: "book_id", on_delete: :restrict
  add_foreign_key "bible_segments", "bible_chapters", column: "chapter_id", on_delete: :restrict
  add_foreign_key "bible_segments", "bible_headings", column: "heading_id", on_delete: :restrict
  add_foreign_key "bible_segments", "bible_translations", column: "translation_id", on_delete: :restrict
  add_foreign_key "bible_verses", "bible_books", column: "book_id", on_delete: :restrict
  add_foreign_key "bible_verses", "bible_chapters", column: "chapter_id", on_delete: :restrict
  add_foreign_key "bible_verses", "bible_translations", column: "translation_id", on_delete: :restrict
end
