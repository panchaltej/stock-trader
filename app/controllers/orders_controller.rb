class OrdersController < ApplicationController
  def create
    Rails.logger.info("********** pending_order_params: #{pending_order_params.inspect}")
    pending_order = PendingOrder.create!(pending_order_params)

    render json: pending_order
  end

  def index
    user_id = params.require(:user_id)
    orders = {
      "pending_orders": PendingOrder.where(user_id: user_id),
      "completed_orders": Order.where(user_id: user_id)
    }
    
    render json: orders
  end

  def pending_order_params
    # Order set to expire after market close (4 PM) on the date provided.
    params.fetch(:order)[:expires_at] = DateTime.strptime(params.fetch(:order)[:expires_at], "%m/%d/%Y") + 16.hours
    params.require(:order).permit(:user_id, :symbol, :type, :price, :quantity, :expires_at)
  end
end