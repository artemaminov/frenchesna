# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_05_092909) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "breed_translations", force: :cascade do |t|
    t.bigint "breed_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "info"
    t.index ["breed_id"], name: "index_breed_translations_on_breed_id"
    t.index ["locale"], name: "index_breed_translations_on_locale"
  end

  create_table "breeds", force: :cascade do |t|
    t.string "title"
    t.integer "order", default: 1
    t.text "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dog_translations", force: :cascade do |t|
    t.bigint "dog_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fullname"
    t.string "nickname"
    t.text "about"
    t.text "awards"
    t.index ["dog_id"], name: "index_dog_translations_on_dog_id"
    t.index ["locale"], name: "index_dog_translations_on_locale"
  end

  create_table "dogs", force: :cascade do |t|
    t.string "fullname"
    t.string "nickname"
    t.date "birthdate"
    t.text "about"
    t.integer "gender", default: 0
    t.text "awards"
    t.boolean "puppy", default: true
    t.boolean "rip", default: false
    t.string "genealogy_link"
    t.bigint "litter_id"
    t.bigint "breed_id"
    t.index ["breed_id"], name: "index_dogs_on_breed_id"
    t.index ["litter_id"], name: "index_dogs_on_litter_id"
  end

  create_table "genealogies", force: :cascade do |t|
    t.bigint "parent_id"
    t.bigint "child_id"
    t.index ["child_id"], name: "index_genealogies_on_child_id"
    t.index ["parent_id"], name: "index_genealogies_on_parent_id"
  end

  create_table "images", force: :cascade do |t|
    t.integer "order", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "viewable_id"
    t.string "viewable_type"
    t.string "viewable_type_scope"
  end

  create_table "litter_translations", force: :cascade do |t|
    t.bigint "litter_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.index ["litter_id"], name: "index_litter_translations_on_litter_id"
    t.index ["locale"], name: "index_litter_translations_on_locale"
  end

  create_table "litters", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "preference_translations", force: :cascade do |t|
    t.bigint "preference_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "about"
    t.index ["locale"], name: "index_preference_translations_on_locale"
    t.index ["preference_id"], name: "index_preference_translations_on_preference_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "about"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "dogs", "litters"
  add_foreign_key "genealogies", "dogs", column: "child_id"
  add_foreign_key "genealogies", "dogs", column: "parent_id"
end
