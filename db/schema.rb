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

ActiveRecord::Schema[8.0].define(version: 2025_04_07_183625) do
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

  create_table "bible_references", force: :cascade do |t|
    t.bigint "translation_id", null: false
    t.bigint "book_id", null: false
    t.bigint "chapter_id", null: false
    t.bigint "heading_id"
    t.string "target", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_bible_references_on_book_id"
    t.index ["chapter_id"], name: "index_bible_references_on_chapter_id"
    t.index ["heading_id"], name: "index_bible_references_on_heading_id"
    t.index ["translation_id"], name: "index_bible_references_on_translation_id"
  end

  create_table "bible_section_segment_associations", force: :cascade do |t|
    t.bigint "section_id", null: false
    t.bigint "segment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_bible_section_segment_associations_on_section_id"
    t.index ["segment_id"], name: "index_bible_section_segment_associations_on_segment_id"
  end

  create_table "bible_sections", force: :cascade do |t|
    t.bigint "translation_id", null: false
    t.bigint "book_id", null: false
    t.bigint "chapter_id", null: false
    t.bigint "heading_id", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_bible_sections_on_book_id"
    t.index ["chapter_id"], name: "index_bible_sections_on_chapter_id"
    t.index ["heading_id"], name: "index_bible_sections_on_heading_id"
    t.index ["translation_id"], name: "index_bible_sections_on_translation_id"
  end

  create_table "bible_segment_verse_associations", force: :cascade do |t|
    t.bigint "segment_id", null: false
    t.bigint "verse_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["segment_id"], name: "index_bible_segment_verse_associations_on_segment_id"
    t.index ["verse_id"], name: "index_bible_segment_verse_associations_on_verse_id"
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

  create_table "exposition_alternative_interpretations", force: :cascade do |t|
    t.bigint "content_id", null: false
    t.string "title", null: false
    t.text "note", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_exposition_alternative_interpretations_on_content_id"
  end

  create_table "exposition_analyses", force: :cascade do |t|
    t.bigint "content_id", null: false
    t.text "part", null: false
    t.text "note", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_exposition_analyses_on_content_id"
  end

  create_table "exposition_batch_requests", force: :cascade do |t|
    t.string "name", null: false
    t.string "status", default: "requested", null: false
    t.json "data"
    t.string "input_file_id"
    t.string "batch_id"
    t.string "error_file_id"
    t.string "output_file_id"
    t.datetime "input_file_uploaded_at"
    t.datetime "in_progress_at"
    t.datetime "cancelling_at"
    t.datetime "expires_at"
    t.datetime "finalizing_at"
    t.datetime "completed_at"
    t.datetime "failed_at"
    t.datetime "cancelled_at"
    t.datetime "expired_at"
    t.integer "requested_total_count"
    t.integer "requested_completed_count"
    t.integer "requested_failed_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.bigint "user_prompt_id", null: false
    t.index ["highlights"], name: "index_exposition_contents_on_highlights", using: :gin
    t.index ["people"], name: "index_exposition_contents_on_people", using: :gin
    t.index ["places"], name: "index_exposition_contents_on_places", using: :gin
    t.index ["reflections"], name: "index_exposition_contents_on_reflections", using: :gin
    t.index ["section_id"], name: "index_exposition_contents_on_section_id"
    t.index ["tags"], name: "index_exposition_contents_on_tags", using: :gin
    t.index ["user_prompt_id"], name: "index_exposition_contents_on_user_prompt_id"
  end

  create_table "exposition_cross_references", force: :cascade do |t|
    t.bigint "content_id", null: false
    t.string "reference", null: false
    t.text "note", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_exposition_cross_references_on_content_id"
  end

  create_table "exposition_insights", force: :cascade do |t|
    t.bigint "content_id", null: false
    t.string "kind", null: false
    t.text "note", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_exposition_insights_on_content_id"
  end

  create_table "exposition_key_themes", force: :cascade do |t|
    t.bigint "content_id", null: false
    t.string "theme", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_exposition_key_themes_on_content_id"
  end

  create_table "exposition_personal_applications", force: :cascade do |t|
    t.bigint "content_id", null: false
    t.string "title", null: false
    t.text "note", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_exposition_personal_applications_on_content_id"
  end

  create_table "exposition_system_prompts", force: :cascade do |t|
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exposition_user_prompts", force: :cascade do |t|
    t.bigint "system_prompt_id"
    t.bigint "section_id", null: false
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "batch_request_id", null: false
    t.index ["batch_request_id"], name: "index_exposition_user_prompts_on_batch_request_id"
    t.index ["section_id"], name: "index_exposition_user_prompts_on_section_id"
    t.index ["system_prompt_id"], name: "index_exposition_user_prompts_on_system_prompt_id"
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
  add_foreign_key "bible_references", "bible_books", column: "book_id", on_delete: :restrict
  add_foreign_key "bible_references", "bible_chapters", column: "chapter_id", on_delete: :restrict
  add_foreign_key "bible_references", "bible_headings", column: "heading_id", on_delete: :restrict
  add_foreign_key "bible_references", "bible_translations", column: "translation_id", on_delete: :restrict
  add_foreign_key "bible_section_segment_associations", "bible_sections", column: "section_id", on_delete: :cascade
  add_foreign_key "bible_section_segment_associations", "bible_segments", column: "segment_id", on_delete: :cascade
  add_foreign_key "bible_sections", "bible_books", column: "book_id", on_delete: :restrict
  add_foreign_key "bible_sections", "bible_chapters", column: "chapter_id", on_delete: :restrict
  add_foreign_key "bible_sections", "bible_headings", column: "heading_id", on_delete: :restrict
  add_foreign_key "bible_sections", "bible_translations", column: "translation_id", on_delete: :restrict
  add_foreign_key "bible_segment_verse_associations", "bible_segments", column: "segment_id", on_delete: :cascade
  add_foreign_key "bible_segment_verse_associations", "bible_verses", column: "verse_id", on_delete: :cascade
  add_foreign_key "bible_segments", "bible_books", column: "book_id", on_delete: :restrict
  add_foreign_key "bible_segments", "bible_chapters", column: "chapter_id", on_delete: :restrict
  add_foreign_key "bible_segments", "bible_headings", column: "heading_id", on_delete: :restrict
  add_foreign_key "bible_segments", "bible_translations", column: "translation_id", on_delete: :restrict
  add_foreign_key "bible_verses", "bible_books", column: "book_id", on_delete: :restrict
  add_foreign_key "bible_verses", "bible_chapters", column: "chapter_id", on_delete: :restrict
  add_foreign_key "bible_verses", "bible_translations", column: "translation_id", on_delete: :restrict
  add_foreign_key "exposition_alternative_interpretations", "exposition_contents", column: "content_id", on_delete: :cascade
  add_foreign_key "exposition_analyses", "exposition_contents", column: "content_id", on_delete: :cascade
  add_foreign_key "exposition_contents", "bible_sections", column: "section_id", on_delete: :restrict
  add_foreign_key "exposition_contents", "exposition_user_prompts", column: "user_prompt_id", on_delete: :restrict
  add_foreign_key "exposition_cross_references", "exposition_contents", column: "content_id", on_delete: :cascade
  add_foreign_key "exposition_insights", "exposition_contents", column: "content_id", on_delete: :cascade
  add_foreign_key "exposition_key_themes", "exposition_contents", column: "content_id", on_delete: :cascade
  add_foreign_key "exposition_personal_applications", "exposition_contents", column: "content_id", on_delete: :cascade
  add_foreign_key "exposition_user_prompts", "bible_sections", column: "section_id", on_delete: :restrict
  add_foreign_key "exposition_user_prompts", "exposition_batch_requests", column: "batch_request_id", on_delete: :restrict
  add_foreign_key "exposition_user_prompts", "exposition_system_prompts", column: "system_prompt_id", on_delete: :restrict
end
