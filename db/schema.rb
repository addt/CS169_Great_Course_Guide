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

ActiveRecord::Schema.define(version: 20171118073332) do

  create_table "awards", force: :cascade do |t|
    t.string   "title"
    t.string   "year"
    t.integer  "professor_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "awards", ["professor_id"], name: "index_awards_on_professor_id"

  create_table "bt_filters", force: :cascade do |t|
    t.string   "filter"
    t.string   "category"
    t.string   "filter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string   "number"
    t.string   "title"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "units",      default: 4
  end

  create_table "draft_courses", force: :cascade do |t|
    t.integer  "course_id"
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "professor"
  end

  create_table "prereqs", force: :cascade do |t|
    t.string   "number"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "professor_courses", force: :cascade do |t|
    t.string   "number"
    t.string   "name"
    t.float    "rating"
    t.string   "term"
    t.integer  "professor_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "professors", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "distinguished",     default: false
    t.string   "distinguishedYear"
    t.string   "category",          default: "EECS"
    t.boolean  "awarded",           default: false
  end

  create_table "user_courses", force: :cascade do |t|
    t.string   "number"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.boolean  "taken"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "uid"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
