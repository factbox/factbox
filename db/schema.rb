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

ActiveRecord::Schema.define(version: 20170731214817) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artifacts", force: :cascade do |t|
    t.integer  "author_id",    null: false
    t.integer  "project_id",   null: false
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "actable_id"
    t.string   "actable_type"
  end

  create_table "artifacts_users", id: false, force: :cascade do |t|
    t.integer "user_id",     null: false
    t.integer "artifact_id", null: false
    t.index ["artifact_id", "user_id"], name: "index_artifacts_users_on_artifact_id_and_user_id", using: :btree
    t.index ["user_id", "artifact_id"], name: "index_artifacts_users_on_user_id_and_artifact_id", using: :btree
  end

  create_table "metodologies", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "notes", force: :cascade do |t|
    t.string "content"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "author_id",                    null: false
    t.integer  "metodology_id"
    t.boolean  "is_public",     default: true
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "projects_users", id: false, force: :cascade do |t|
    t.integer "user_id",    null: false
    t.integer "project_id", null: false
    t.index ["project_id", "user_id"], name: "index_projects_users_on_project_id_and_user_id", using: :btree
    t.index ["user_id", "project_id"], name: "index_projects_users_on_user_id_and_project_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.string   "lastName"
    t.string   "login"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "work"
    t.string   "location"
  end

end
