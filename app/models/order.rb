class Order < ApplicationRecord
  validates :status, presence: true
  # :customer_name, :customer_email, :customer_address,
  # :cc_number,:cc_expiration, :cc_ccv,
  # :zip_code, presence: true

  def self.total_cost_order
    total = 0
    orders_items = OrderItems.where(order_id: @order.id)
    order_items.each do |order_item|
    total += order_item.quantity * order_item.product.price
  end
    return total
  end





end
