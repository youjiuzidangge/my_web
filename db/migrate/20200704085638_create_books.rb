class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title, limit: 16, null: false, comment: "名称"
      t.integer :stock, null: false, comment: "库存"
      t.integer :fee, null: false, comment: "出借费用"
      t.timestamps
    end
  end
end
