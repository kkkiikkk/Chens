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

ActiveRecord::Schema[7.2].define(version: 2024_09_30_073135) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "chat_members", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.bigint "user_id", null: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_chat_members_on_chat_id"
    t.index ["user_id"], name: "index_chat_members_on_user_id"
  end

  create_table "chats", force: :cascade do |t|
    t.string "name"
    t.string "chat_type"
    t.string "chat_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "workspace_id", null: false
    t.index ["workspace_id"], name: "index_chats_on_workspace_id"
  end

  create_table "friends", force: :cascade do |t|
    t.bigint "user1_id", null: false
    t.bigint "user2_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user1_id"], name: "index_friends_on_user1_id"
    t.index ["user2_id"], name: "index_friends_on_user2_id"
  end

  create_table "invites", force: :cascade do |t|
    t.string "email"
    t.string "token", null: false
    t.bigint "user_id"
    t.bigint "workspace_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invite_type", default: "public"
    t.string "status", default: "unconfirmed"
    t.index ["token"], name: "index_invites_on_token", unique: true
    t.index ["user_id"], name: "index_invites_on_user_id"
    t.index ["workspace_id"], name: "index_invites_on_workspace_id"
  end

  create_table "message_reads", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "message_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id", "user_id"], name: "index_message_reads_on_message_id_and_user_id", unique: true
    t.index ["message_id"], name: "index_message_reads_on_message_id"
    t.index ["user_id"], name: "index_message_reads_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "text", null: false
    t.bigint "sender_id", null: false
    t.bigint "chat_id", null: false
    t.bigint "reply_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["reply_id"], name: "index_messages_on_reply_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "user_workspaces", force: :cascade do |t|
    t.string "profile_description"
    t.string "profile_name"
    t.string "profile_status", default: "online"
    t.string "profile_title"
    t.bigint "user_id", null: false
    t.bigint "workspace_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "member", null: false
    t.index ["user_id"], name: "index_user_workspaces_on_user_id"
    t.index ["workspace_id"], name: "index_user_workspaces_on_workspace_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workspaces", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_workspaces_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chat_members", "chats"
  add_foreign_key "chat_members", "users"
  add_foreign_key "chats", "workspaces"
  add_foreign_key "friends", "users", column: "user1_id"
  add_foreign_key "friends", "users", column: "user2_id"
  add_foreign_key "invites", "users"
  add_foreign_key "invites", "workspaces"
  add_foreign_key "message_reads", "messages"
  add_foreign_key "message_reads", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "messages", column: "reply_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "user_workspaces", "users"
  add_foreign_key "user_workspaces", "workspaces"
  add_foreign_key "workspaces", "users"
end
