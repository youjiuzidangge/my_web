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

ActiveRecord::Schema.define(version: 2020_07_04_085722) do

  create_table "books", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", limit: 16, null: false, comment: "名称"
    t.integer "stock", null: false, comment: "库存"
    t.integer "fee", null: false, comment: "出借费用"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "category", null: false, comment: "交易流水分类"
    t.integer "user_id", null: false, comment: "用户id"
    t.string "username", limit: 16, comment: "用户名"
    t.integer "book_id", null: false, comment: "书籍id"
    t.string "book_title", limit: 16
    t.datetime "loan_at", null: false, comment: "借出或者返回时间"
    t.boolean "is_recorded", default: false, null: false, comment: "是否入账"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", comment: "用户表", force: :cascade do |t|
    t.string "account", limit: 16, null: false, comment: "账号"
    t.string "username", limit: 16, comment: "用户名"
    t.integer "balance", comment: "余额，单位为分"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users_books", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "用户id"
    t.integer "book_id", null: false, comment: "书籍id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
