class ExecuteOrdersJob < ApplicationJob
  queue_as :default

  def perform(incoming_order)
    Rails.logger.info("********** Running ExecuteOrdersJob")
    matching_pending_order = nil
    if incoming_order.buy?
      matching_pending_order = PendingOrder.where(symbol: incoming_order.symbol)
                                          .where(type: "sell")
                                          .where("expires_at > ?", DateTime.current)
                                          .where("price <= ?", incoming_order.price)
                                          .where.not(user_id: incoming_order.user_id)
                                          .order(price: :asc)
                                          .first
    else
      matching_pending_order = PendingOrder.where(symbol: incoming_order.symbol)
                                          .where(type: "buy")
                                          .where("expires_at > ?", DateTime.current)
                                          .where("price >= ?", incoming_order.price)
                                          .where.not(user_id: incoming_order.user_id)
                                          .order(price: :desc)
                                          .first
    end

    if matching_pending_order.present?
      Rails.logger.info("********** matching order found: #{matching_pending_order.inspect}")
      ActiveRecord::Base.transaction do
        execute_orders(incoming_order, matching_pending_order)
        # User can be notified here via an Email and App Notification
      end
    end
  end

  def execute_orders(incoming_order, matching_order)
    # if incoming/matching order can only execute partially we'll update them
    # else we'll execute them
    quantity_filled = [incoming_order.quantity, matching_order.quantity].min
    orders_to_execute = [incoming_order, matching_order]                            # execute orders (partially or complete)
    orders_to_update = orders_to_execute.select {|o| o.quantity > quantity_filled}  # update quantity for partially executed PendingOrders
    completed_orders = orders_to_execute.select {|o| o.quantity == quantity_filled} # completed orders should be removed from PendingOrders

    orders_to_execute.each do |o|
      order_params = {
        user_id: o.user_id,
        symbol: o.symbol,
        type: o.type,
        filled_at_price: matching_order.price,
        quantity: quantity_filled,
        status: "filled",
        order_place_at: o.created_at,
        filled_at: DateTime.current
      }

      order = Order.create!(order_params)
      Rails.logger.info("********** order filled: #{order.inspect}")
    end

    orders_to_update.each do |o|
      order = o.update!(quantity: o.quantity - quantity_filled)
      Rails.logger.info("********** updated partially filled order: #{order.inspect}")
    end

    completed_orders.each do |o|
      order = o.destroy!
      Rails.logger.info("********** removed completed order from pending_orders: #{order.inspect}")
    end
  end
end
