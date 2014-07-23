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

ActiveRecord::Schema.define(version: 20140727111230) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string   "name",       null: false
    t.string   "ref"
  end

  create_table "sources", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "label",                       null: false
    t.string   "description"
    t.string   "sha256",                      null: false
    t.string   "file_name"
    t.string   "mime_type"
    t.string   "charset"
    t.boolean  "file_header", default: false, null: false
  end

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
  end

end
