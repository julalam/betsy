class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_one :merchant, :through => :product


  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }


  def total
    sum = product.price * quantity
    return sum
  end

  def self.subtotal(order_item)
    result = order_item.quantity * order_item.product.price
    return result
  end

  def self.total_cost(collection)
    total = 0
    collection.each do |order_item|
      total += subtotal(order_item)
    end
    if total < 50
      total += 10
    end
    return total
  end


end
