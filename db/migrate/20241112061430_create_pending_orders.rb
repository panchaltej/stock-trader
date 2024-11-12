class CreatePendingOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :pending_orders do |t|
      t.bigint :user_id, null: false, index: true
      t.string :symbol, null: false, index: true
      t.string :type, null: false
      t.decimal :price, precision: 11, scale: 4, null: false
      t.bigint :quantity
      t.datetime :expires_at

      t.timestamps
    end
  end
end
