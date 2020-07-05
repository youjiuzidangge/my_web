class AddIncomeToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :income, :integer, after: :fee, default: 0, comment: "收入（只包含已收录的部分）"
  end
end