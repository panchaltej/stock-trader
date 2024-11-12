class CancelExpiredPendingOrdersJob < ApplicationJob
  queue_as :default

  # This is scheduled to run at 16:01 everyday to cancel orders that expired that day
  def perform(*args)
    Rails.logger.info("********** Running CancelExpiredPendingOrdersJob")
    expired_orders = PendingOrder.where("expires_at < ?", DateTime.current)

    expired_orders.each do |o|
      order_params = {
        user_id: o.user_id,
        symbol: o.symbol,
        type: o.type,
        quantity: o.quantity,
        status: "expired",
        order_place_at: o.created_at,
        expired_at: o.expires_at
      }
      ActiveRecord::Base.transaction do
        order = Order.create!(order_params)
        o.destroy!
      end
      # User can be notified here via an Email and App Notification
      
      Rails.logger.info("********** order expired: #{order.inspect}")
    end
  end
end
