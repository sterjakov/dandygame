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

ActiveRecord::Schema.define(version: 20150202191036) do

  create_table "activations", force: :cascade do |t|
    t.integer  "training_id", limit: 4
    t.integer  "day_number",  limit: 4
    t.integer  "user_id",     limit: 4
    t.integer  "money",       limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "alt_name",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size",    limit: 4
    t.integer  "assetable_id",      limit: 4
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width",             limit: 4
    t.integer  "height",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "day_id",      limit: 4
    t.text     "description", limit: 65535
    t.integer  "bad",         limit: 4
    t.integer  "good",        limit: 4
    t.integer  "status",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry",    limit: 255
  end

  add_index "comments", ["ancestry"], name: "index_comments_on_ancestry", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.text     "description", limit: 65535
    t.string   "email",       limit: 255
    t.string   "theme",       limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "day_attachments", force: :cascade do |t|
    t.string   "day_id",     limit: 255
    t.string   "attachment", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "days", force: :cascade do |t|
    t.string   "training_id", limit: 255
    t.integer  "number",      limit: 4
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.text     "html",        limit: 65535
    t.text     "css",         limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "training_id", limit: 4
    t.text     "description", limit: 65535
    t.integer  "bad",         limit: 4
    t.integer  "good",        limit: 4
    t.integer  "status",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mytrainings", force: :cascade do |t|
    t.integer  "training_id",  limit: 4
    t.integer  "user_id",      limit: 4
    t.integer  "day_number",   limit: 4
    t.integer  "status",       limit: 4, default: 0
    t.integer  "viewed",       limit: 4, default: 0
    t.datetime "activated_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "item_id",    limit: 4
    t.integer  "status",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "questions", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.integer  "day_id",             limit: 4
    t.integer  "status",             limit: 4,     default: 0
    t.text     "description",        limit: 65535
    t.integer  "reviewed",           limit: 4,     default: 0
    t.integer  "answer_author_id",   limit: 4
    t.text     "answer_description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simple_captcha_data", force: :cascade do |t|
    t.string   "key",        limit: 40
    t.string   "value",      limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], name: "idx_key", using: :btree

  create_table "training_attachments", force: :cascade do |t|
    t.integer  "training_id", limit: 4
    t.string   "attachment",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trainings", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "alt_name",         limit: 255
    t.text     "description",      limit: 65535
    t.text     "min_description",  limit: 65535
    t.integer  "people_count",     limit: 4,     default: 0
    t.integer  "feedback_count",   limit: 4,     default: 0
    t.integer  "day_count",        limit: 4,     default: 0
    t.integer  "free_day",         limit: 4,     default: 0
    t.integer  "price",            limit: 4,     default: 0
    t.string   "icon",             limit: 255
    t.integer  "weight",           limit: 4
    t.text     "html",             limit: 65535
    t.text     "css",              limit: 65535
    t.integer  "category_id",      limit: 4
    t.integer  "status",           limit: 4,     default: 0
    t.string   "meta_description", limit: 255
    t.string   "meta_keywords",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_days", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.integer "day_id",  limit: 4
  end

  add_index "user_days", ["day_id"], name: "index_user_days_on_day_id", using: :btree
  add_index "user_days", ["user_id"], name: "index_user_days_on_user_id", using: :btree

  create_table "user_trainings", id: false, force: :cascade do |t|
    t.integer "user_id",     limit: 4
    t.integer "training_id", limit: 4
  end

  add_index "user_trainings", ["training_id"], name: "index_user_trainings_on_training_id", using: :btree
  add_index "user_trainings", ["user_id"], name: "index_user_trainings_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",          limit: 255
    t.string   "new_email",      limit: 255
    t.string   "password_hash",  limit: 255
    t.string   "password_salt",  limit: 255
    t.string   "nickname",       limit: 255
    t.datetime "birthday"
    t.integer  "age",            limit: 4
    t.integer  "gender",         limit: 4
    t.integer  "country",        limit: 4
    t.integer  "city",           limit: 4
    t.integer  "subscribe",      limit: 4
    t.integer  "money",          limit: 4,     default: 0
    t.integer  "role",           limit: 4
    t.text     "description",    limit: 65535
    t.string   "avatar",         limit: 255
    t.string   "ip",             limit: 255
    t.integer  "referer",        limit: 4
    t.integer  "confirm",        limit: 4
    t.string   "auth_token",     limit: 255
    t.string   "email_token",    limit: 255
    t.string   "password_token", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vkontakte_id",   limit: 4
    t.integer  "notify_comment", limit: 4
    t.integer  "notify_day",     limit: 4
    t.integer  "notify_news",    limit: 4
  end

end
