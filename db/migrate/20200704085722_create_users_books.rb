class CreateUsersBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :users_books do |t|
      t.integer :user_id, null: false, comment: '用户id'
      t.integer :book_id, null: false, comment: '书籍id'

      t.timestamps
    end
  end
end
