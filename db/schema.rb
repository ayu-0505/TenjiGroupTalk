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

ActiveRecord::Schema[8.0].define(version: 2025_09_12_000246) do
  create_table "brailles", force: :cascade do |t|
    t.text "original_text", null: false
    t.text "raised_braille", null: false
    t.text "indented_braille", null: false
    t.integer "user_id", null: false
    t.string "brailleable_type", null: false
    t.integer "brailleable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brailleable_type", "brailleable_id"], name: "index_brailles_on_brailleable"
    t.index ["user_id"], name: "index_brailles_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "description", null: false
    t.integer "user_id", null: false
    t.integer "talk_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["talk_id"], name: "index_comments_on_talk_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "admin_id", null: false
    t.index ["admin_id"], name: "index_groups_on_admin_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.string "token", null: false
    t.datetime "expires_at"
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_invitations_on_group_id"
    t.index ["token"], name: "index_invitations_on_token", unique: true
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_memberships_on_group_id"
    t.index ["user_id", "group_id"], name: "index_memberships_on_user_id_and_group_id", unique: true
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.boolean "read", default: false, null: false
    t.integer "user_id", null: false
    t.string "notifiable_type", null: false
    t.integer "notifiable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "talk_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["talk_id"], name: "index_subscriptions_on_talk_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "talks", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_talks_on_group_id"
    t.index ["user_id"], name: "index_talks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "uid", null: false
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "brailles", "users"
  add_foreign_key "comments", "talks"
  add_foreign_key "comments", "users"
  add_foreign_key "groups", "users", column: "admin_id"
  add_foreign_key "invitations", "groups"
  add_foreign_key "invitations", "users"
  add_foreign_key "memberships", "groups"
  add_foreign_key "memberships", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "subscriptions", "talks"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "talks", "groups"
  add_foreign_key "talks", "users"
end
