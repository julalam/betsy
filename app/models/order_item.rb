class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product



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
