class AddQuantityAndTotalFeeToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :quantity, :integer, null: false, after: :category,comment: '借阅数'
    add_column :transactions, :total_fee, :integer, null: false, after: :quantity,comment: '总费用'
  end
end
