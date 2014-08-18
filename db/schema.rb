# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140818103521) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: true do |t|
    t.string   "zone"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "headers", force: true do |t|
    t.integer  "source_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       null: false
    t.integer  "type",       null: false
    t.integer  "position",   null: false
  end

  create_table "operations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",        null: false
    t.string   "ref"
    t.text     "description"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "sources", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "label",       null: false
    t.string   "description"
    t.string   "sha256",      null: false
    t.string   "file_name"
    t.integer  "rows_count"
    t.integer  "user_id",     null: false
  end

  add_index "sources", ["user_id"], name: "index_sources_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                            null: false
    t.string   "email",                           null: false
    t.string   "password_digest",                 null: false
    t.boolean  "admin",           default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "works", force: true do |t|
    t.integer  "operation_id",     null: false
    t.integer  "source_id",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "started_at"
    t.datetime "processed_at"
    t.string   "parameters",       null: false, array: true
    t.datetime "failed_at"
    t.datetime "terminated_at"
    t.integer  "target_source_id"
    t.json     "results"
    t.integer  "user_id",          null: false
  end

  add_index "works", ["user_id"], name: "index_works_on_user_id", using: :btree

end
