# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_12_133845) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "trainings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "word_id", null: false
    t.integer "result", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_input", default: "", null: false
    t.index ["user_id"], name: "index_trainings_on_user_id"
    t.index ["word_id"], name: "index_trainings_on_word_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "verb_forms", force: :cascade do |t|
    t.bigint "word_id", null: false
    t.integer "tense", null: false
    t.integer "pronoun", null: false
    t.string "spanish", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["word_id"], name: "index_verb_forms_on_word_id"
  end

  create_table "words", force: :cascade do |t|
    t.string "spanish", null: false
    t.string "russian", null: false
    t.string "articles", default: [], null: false, array: true
    t.integer "part_of_speech", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "trainings", "users"
  add_foreign_key "trainings", "words"
  add_foreign_key "verb_forms", "words"
end
