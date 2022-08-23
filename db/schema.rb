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

ActiveRecord::Schema[7.0].define(version: 2020_07_05_180010) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "title", limit: 16, null: false, comment: "名称"
    t.integer "stock", null: false, comment: "库存"
    t.integer "fee", null: false, comment: "出借费用"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "income", default: 0, comment: "收入（只包含已收录的部分）"
    t.integer "total_stock", null: false, comment: "总库存"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "category", null: false, comment: "交易流水分类"
    t.integer "user_id", null: false, comment: "用户id"
    t.string "username", limit: 16, comment: "用户名"
    t.integer "book_id", null: false, comment: "书籍id"
    t.string "book_title", limit: 16
    t.datetime "loan_at", precision: nil, null: false, comment: "借出或者返回时间"
    t.boolean "is_recorded", default: false, null: false, comment: "是否入账"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "quantity", null: false, comment: "借阅数"
    t.integer "total_fee", null: false, comment: "总费用"
  end

  create_table "users", comment: "用户表", force: :cascade do |t|
    t.string "account", limit: 16, null: false, comment: "账号"
    t.string "username", limit: 16, comment: "用户名"
    t.integer "balance", comment: "余额，单位为分"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "users_books", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "用户id"
    t.integer "book_id", null: false, comment: "书籍id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "quantity", null: false, comment: "借阅数"
  end

end
