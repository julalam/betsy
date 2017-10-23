class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  # Make a method for this and put it in _orderitem_summary
  def self.total_cost(order_item)
    result = order_item.quantity * order_item.product.price
    return result
  end
end
