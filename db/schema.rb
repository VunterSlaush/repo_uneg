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

ActiveRecord::Schema.define(version: 20160331020648) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string "nombre"
  end

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "content_id"
    t.text     "cuerpo",     null: false
    t.datetime "creado"
  end

  add_index "comments", ["content_id"], name: "index_comments_on_content_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "contentcategories", force: true do |t|
    t.integer "content_id"
    t.integer "category_id"
  end

  create_table "contents", force: true do |t|
    t.integer  "user_id"
    t.string   "titulo",               null: false
    t.text     "descripcion",          null: false
    t.date     "fecha_publicacion",    null: false
    t.integer  "cantidad_descargas",   null: false
    t.boolean  "status",               null: false
    t.string   "imagen_file_name"
    t.string   "imagen_content_type"
    t.integer  "imagen_file_size"
    t.datetime "imagen_updated_at"
    t.string   "archivo_file_name"
    t.string   "archivo_content_type"
    t.integer  "archivo_file_size"
    t.datetime "archivo_updated_at"
  end

  add_index "contents", ["user_id"], name: "index_contents_on_user_id", using: :btree

  create_table "petitions", force: true do |t|
    t.integer "user_id"
    t.text    "razon"
  end

  create_table "rates", force: true do |t|
    t.integer "user_id",    null: false
    t.integer "content_id", null: false
    t.float   "valor",      null: false
  end

  create_table "users", force: true do |t|
    t.string   "email",               default: "", null: false
    t.string   "encrypted_password",  default: "", null: false
    t.string   "nombre",              default: "", null: false
    t.string   "pregunta_secreta",                 null: false
    t.string   "respuesta_secreta",                null: false
    t.integer  "sign_in_count",       default: 0,  null: false
    t.integer  "administration_id"
    t.datetime "remember_created_at"
  end

  add_index "users", ["administration_id"], name: "index_users_on_administration_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "visits", force: true do |t|
    t.integer "user_id"
    t.time    "hora_entrada",  null: false
    t.time    "hora_salida",   null: false
    t.date    "fecha_entrada", null: false
    t.date    "fecha_salida",  null: false
  end

  add_index "visits", ["user_id"], name: "index_visits_on_user_id", using: :btree

end
