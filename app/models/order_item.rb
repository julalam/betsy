class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def self.subtotal(order_item)
    result = order_item.quantity * order_item.product.price
    return result
  end

  def self.total_cost(collection)
    total = 0
    collection.each do |order_item|
      total += subtotal(order_item)
    end
    return total
  end


end
