class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, comment: "用户表" do |t|
      t.string :account, limit: 16, null: false, comment: "账号"
      t.string :username, limit: 16, null: true, comment: "用户名"
      t.integer :balance, comment: "余额，单位为分"

      t.timestamps
    end
  end
end
