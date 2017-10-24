class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # Make a method for this and put it in _orderitem_summary
  # def total_cost(cost)
  #   cost = @quantity * cost
  # return result
  # end

  def total
    sum = product.price * quantity
    return sum
  end

  def self.total_cost(order_item)
    result = order_item.quantity * order_item.product.price
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
