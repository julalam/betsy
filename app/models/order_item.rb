class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_one :merchant, :through => :product


  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

#calculates the total cost of an order item, call it on an instance of order_item
#if we have time, choose between this and subtotal and use just one of them since they serve the same function.
  def total
    sum = product.price * quantity
    return sum
  end

# calculates the total cost of an order_item, but you pass in the order item.
#if we have time, choose between this and subtotal and use just one of them since they serve the same function.
  def self.subtotal(order_item)
    result = order_item.quantity * order_item.product.price
    return result
  end

# this calculates the cost of a collection of items (i.e. an order)
  def self.total_cost(collection)
    total = 0
    collection.each do |order_item|
      total += subtotal(order_item)
    end
    if total < 5000
      total += 1000
    end
    return total
  end


end
