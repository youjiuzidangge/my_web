class AddQuantityToUsersBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :users_books, :quantity, :integer, null: false, after: :book_id,comment: '借阅数'
  end
end