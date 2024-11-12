class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.bigint :user_id, null: false, index: true
      t.string :symbol, null: false, index: true
      t.string :type, null: false
      t.decimal :filled_at_price, precision: 11, scale: 4
      t.bigint :quantity, null: false
      t.string :status
      t.datetime :order_place_at
      t.datetime :expired_at
      t.datetime :filled_at

      t.timestamps
    end
  end
end
