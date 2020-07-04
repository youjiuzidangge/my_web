class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :category, null: false, comment: '交易流水分类'
      t.integer :user_id, null: false, comment: '用户id'
      t.string :username, limit: 16, null: true, comment: '用户名'
      t.integer :book_id, null: false, comment: '书籍id'
      t.string :book_title, limit: 16, null: true, commit: '书名'
      t.datetime :loan_at, null: false, comment: '借出或者返回时间'
      t.boolean :is_recorded, null: false, default: false, comment: '是否入账'

      t.timestamps
    end
  end
end
