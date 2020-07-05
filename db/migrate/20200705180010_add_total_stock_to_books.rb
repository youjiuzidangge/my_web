class AddTotalStockToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :total_stock, :integer, after: :stock, null: false, comment: "总库存"
  end
end
