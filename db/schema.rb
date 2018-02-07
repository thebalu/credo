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

ActiveRecord::Schema.define(version: 20180207163328) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.text     "front"
    t.text     "back"
    t.integer  "deck_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "decks", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "klass_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "klasses", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "konfigs", force: :cascade do |t|
    t.integer  "deck_id"
    t.integer  "student_id"
    t.string   "grad_steps",          default: "1 10"
    t.integer  "starting_step",       default: 1
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "lapse_starting_step"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer  "card_id"
    t.integer  "student_id"
    t.integer  "due"
    t.integer  "queue",         default: 0
    t.boolean  "lapsed",        default: false
    t.integer  "learning_step"
    t.integer  "reps",          default: 0
    t.integer  "interval",      default: 0
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.decimal  "ef",            default: "2.5"
  end

  create_table "students", force: :cascade do |t|
    t.string   "name"
    t.integer  "klass_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
