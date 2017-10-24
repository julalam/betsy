class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_one :merchant, :through => :product


  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }


  def total
    sum = product.price * quantity
    return sum
  end

  def self.total_cost(order_item)
    result = order_item.quantity * order_item.product.price
    if result < 50
      result += 10
    end
    return result
  end


  def self.total_cost(collection)
    total = 0
    if collection[0].nil?
      total += collection.quantity * collection.product.price
    else
      collection.each do |order_item|
        total += order_item.quantity * order_item.product.price
      end
    end
    return total
  end


end
