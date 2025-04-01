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

ActiveRecord::Schema[8.0].define(version: 2025_04_01_040656) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bibles", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", limit: 3, null: false
    t.text "statement", null: false
    t.string "rights_holder_name", null: false
    t.string "rights_holder_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_bibles_on_code", unique: true
  end

  create_table "books", force: :cascade do |t|
    t.bigint "bible_id", null: false
    t.string "title", null: false
    t.integer "number", null: false
    t.string "code", limit: 3, null: false
    t.string "slug", null: false
    t.string "testament", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bible_id", "code"], name: "index_books_on_bible_id_and_code", unique: true
    t.index ["bible_id"], name: "index_books_on_bible_id"
  end

  create_table "chapters", force: :cascade do |t|
    t.bigint "bible_id", null: false
    t.bigint "book_id", null: false
    t.integer "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bible_id", "book_id", "number"], name: "index_chapters_on_bible_id_and_book_id_and_number", unique: true
    t.index ["bible_id"], name: "index_chapters_on_bible_id"
    t.index ["book_id"], name: "index_chapters_on_book_id"
  end

  create_table "exposition_alternative_interpretations", force: :cascade do |t|
    t.bigint "exposition_content_id", null: false
    t.string "title", null: false
    t.text "note", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exposition_content_id"], name: "idx_on_exposition_content_id_705a740ad5"
  end

  create_table "exposition_analyses", force: :cascade do |t|
    t.bigint "exposition_content_id", null: false
    t.string "part", null: false
    t.text "note", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exposition_content_id"], name: "index_exposition_analyses_on_exposition_content_id"
  end

  create_table "exposition_contents", force: :cascade do |t|
    t.bigint "section_id", null: false
    t.text "summary", null: false
    t.text "context", null: false
    t.text "highlights", default: [], null: false, array: true
    t.text "reflections", default: [], null: false, array: true
    t.string "interpretation_type", null: false
    t.string "people", default: [], null: false, array: true
    t.string "places", default: [], null: false, array: true
    t.string "tags", default: [], null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "exposition_user_prompt_id", null: false
    t.index ["exposition_user_prompt_id"], name: "index_exposition_contents_on_exposition_user_prompt_id"
    t.index ["highlights"], name: "index_exposition_contents_on_highlights", using: :gin
    t.index ["people"], name: "index_exposition_contents_on_people", using: :gin
    t.index ["places"], name: "index_exposition_contents_on_places", using: :gin
    t.index ["reflections"], name: "index_exposition_contents_on_reflections", using: :gin
    t.index ["section_id"], name: "index_exposition_contents_on_section_id"
    t.index ["tags"], name: "index_exposition_contents_on_tags", using: :gin
  end

  create_table "exposition_cross_references", force: :cascade do |t|
    t.bigint "exposition_content_id", null: false
    t.string "reference", null: false
    t.text "note", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exposition_content_id"], name: "index_exposition_cross_references_on_exposition_content_id"
  end

  create_table "exposition_insights", force: :cascade do |t|
    t.bigint "exposition_content_id", null: false
    t.string "kind", null: false
    t.text "note", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exposition_content_id"], name: "index_exposition_insights_on_exposition_content_id"
  end

  create_table "exposition_key_themes", force: :cascade do |t|
    t.bigint "exposition_content_id", null: false
    t.string "theme", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exposition_content_id"], name: "index_exposition_key_themes_on_exposition_content_id"
  end

  create_table "exposition_personal_applications", force: :cascade do |t|
    t.bigint "exposition_content_id", null: false
    t.string "title", null: false
    t.text "note", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exposition_content_id"], name: "idx_on_exposition_content_id_b900e2aa68"
  end

  create_table "exposition_system_prompts", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exposition_user_prompts", force: :cascade do |t|
    t.bigint "exposition_system_prompt_id"
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exposition_system_prompt_id"], name: "index_exposition_user_prompts_on_exposition_system_prompt_id"
  end

  create_table "footnotes", force: :cascade do |t|
    t.bigint "bible_id", null: false
    t.bigint "book_id", null: false
    t.bigint "chapter_id", null: false
    t.bigint "verse_id"
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bible_id"], name: "index_footnotes_on_bible_id"
    t.index ["book_id"], name: "index_footnotes_on_book_id"
    t.index ["chapter_id"], name: "index_footnotes_on_chapter_id"
    t.index ["verse_id"], name: "index_footnotes_on_verse_id"
  end

  create_table "fragments", force: :cascade do |t|
    t.bigint "bible_id", null: false
    t.bigint "book_id", null: false
    t.bigint "segment_id", null: false
    t.bigint "chapter_id", null: false
    t.bigint "heading_id", null: false
    t.bigint "verse_id"
    t.boolean "show_verse", null: false
    t.string "kind", null: false
    t.text "content", null: false
    t.integer "position", null: false
    t.string "fragmentable_type"
    t.bigint "fragmentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bible_id"], name: "index_fragments_on_bible_id"
    t.index ["book_id"], name: "index_fragments_on_book_id"
    t.index ["chapter_id"], name: "index_fragments_on_chapter_id"
    t.index ["fragmentable_type", "fragmentable_id"], name: "index_fragments_on_fragmentable"
    t.index ["heading_id"], name: "index_fragments_on_heading_id"
    t.index ["segment_id"], name: "index_fragments_on_segment_id"
    t.index ["verse_id"], name: "index_fragments_on_verse_id"
  end

  create_table "headings", force: :cascade do |t|
    t.bigint "bible_id", null: false
    t.bigint "book_id", null: false
    t.bigint "chapter_id", null: false
    t.string "kind", null: false
    t.integer "level", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bible_id"], name: "index_headings_on_bible_id"
    t.index ["book_id"], name: "index_headings_on_book_id"
    t.index ["chapter_id"], name: "index_headings_on_chapter_id"
  end

  create_table "references", force: :cascade do |t|
    t.bigint "bible_id", null: false
    t.bigint "book_id", null: false
    t.bigint "chapter_id", null: false
    t.bigint "heading_id"
    t.string "target", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bible_id"], name: "index_references_on_bible_id"
    t.index ["book_id"], name: "index_references_on_book_id"
    t.index ["chapter_id"], name: "index_references_on_chapter_id"
    t.index ["heading_id"], name: "index_references_on_heading_id"
  end

  create_table "section_segment_associations", force: :cascade do |t|
    t.bigint "section_id", null: false
    t.bigint "segment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_section_segment_associations_on_section_id"
    t.index ["segment_id"], name: "index_section_segment_associations_on_segment_id"
  end

  create_table "sections", force: :cascade do |t|
    t.bigint "bible_id", null: false
    t.bigint "book_id", null: false
    t.bigint "chapter_id", null: false
    t.bigint "heading_id", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bible_id"], name: "index_sections_on_bible_id"
    t.index ["book_id"], name: "index_sections_on_book_id"
    t.index ["chapter_id"], name: "index_sections_on_chapter_id"
    t.index ["heading_id"], name: "index_sections_on_heading_id"
  end

  create_table "segment_verse_associations", force: :cascade do |t|
    t.bigint "segment_id", null: false
    t.bigint "verse_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["segment_id"], name: "index_segment_verse_associations_on_segment_id"
    t.index ["verse_id"], name: "index_segment_verse_associations_on_verse_id"
  end

  create_table "segments", force: :cascade do |t|
    t.bigint "bible_id", null: false
    t.bigint "book_id", null: false
    t.bigint "chapter_id", null: false
    t.bigint "heading_id", null: false
    t.integer "usx_position", null: false
    t.string "usx_style", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bible_id"], name: "index_segments_on_bible_id"
    t.index ["book_id"], name: "index_segments_on_book_id"
    t.index ["chapter_id"], name: "index_segments_on_chapter_id"
    t.index ["heading_id"], name: "index_segments_on_heading_id"
  end

  create_table "verses", force: :cascade do |t|
    t.bigint "bible_id", null: false
    t.bigint "book_id", null: false
    t.bigint "chapter_id", null: false
    t.integer "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bible_id", "book_id", "chapter_id", "number"], name: "index_verses_on_bible_id_and_book_id_and_chapter_id_and_number", unique: true
    t.index ["bible_id"], name: "index_verses_on_bible_id"
    t.index ["book_id"], name: "index_verses_on_book_id"
    t.index ["chapter_id"], name: "index_verses_on_chapter_id"
  end

  add_foreign_key "books", "bibles", on_delete: :restrict
  add_foreign_key "chapters", "bibles", on_delete: :restrict
  add_foreign_key "chapters", "books", on_delete: :restrict
  add_foreign_key "exposition_alternative_interpretations", "exposition_contents", on_delete: :cascade
  add_foreign_key "exposition_analyses", "exposition_contents", on_delete: :cascade
  add_foreign_key "exposition_contents", "exposition_user_prompts", on_delete: :restrict
  add_foreign_key "exposition_contents", "sections", on_delete: :restrict
  add_foreign_key "exposition_cross_references", "exposition_contents", on_delete: :cascade
  add_foreign_key "exposition_insights", "exposition_contents", on_delete: :cascade
  add_foreign_key "exposition_key_themes", "exposition_contents", on_delete: :cascade
  add_foreign_key "exposition_personal_applications", "exposition_contents", on_delete: :cascade
  add_foreign_key "exposition_user_prompts", "exposition_system_prompts", on_delete: :restrict
  add_foreign_key "footnotes", "bibles", on_delete: :restrict
  add_foreign_key "footnotes", "books", on_delete: :restrict
  add_foreign_key "footnotes", "chapters", on_delete: :restrict
  add_foreign_key "footnotes", "verses", on_delete: :restrict
  add_foreign_key "fragments", "bibles", on_delete: :restrict
  add_foreign_key "fragments", "books", on_delete: :restrict
  add_foreign_key "fragments", "chapters", on_delete: :restrict
  add_foreign_key "fragments", "headings", on_delete: :restrict
  add_foreign_key "fragments", "segments", on_delete: :restrict
  add_foreign_key "fragments", "verses", on_delete: :restrict
  add_foreign_key "headings", "bibles", on_delete: :restrict
  add_foreign_key "headings", "books", on_delete: :restrict
  add_foreign_key "headings", "chapters", on_delete: :restrict
  add_foreign_key "references", "bibles", on_delete: :restrict
  add_foreign_key "references", "books", on_delete: :restrict
  add_foreign_key "references", "chapters", on_delete: :restrict
  add_foreign_key "references", "headings", on_delete: :restrict
  add_foreign_key "section_segment_associations", "sections", on_delete: :cascade
  add_foreign_key "section_segment_associations", "segments", on_delete: :cascade
  add_foreign_key "sections", "bibles", on_delete: :restrict
  add_foreign_key "sections", "books", on_delete: :restrict
  add_foreign_key "sections", "chapters", on_delete: :restrict
  add_foreign_key "sections", "headings", on_delete: :restrict
  add_foreign_key "segment_verse_associations", "segments", on_delete: :cascade
  add_foreign_key "segment_verse_associations", "verses", on_delete: :cascade
  add_foreign_key "segments", "bibles", on_delete: :restrict
  add_foreign_key "segments", "books", on_delete: :restrict
  add_foreign_key "segments", "chapters", on_delete: :restrict
  add_foreign_key "segments", "headings", on_delete: :restrict
  add_foreign_key "verses", "bibles", on_delete: :restrict
  add_foreign_key "verses", "books", on_delete: :restrict
  add_foreign_key "verses", "chapters", on_delete: :restrict
end
