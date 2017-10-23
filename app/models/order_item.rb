class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  # Make a method for this and put it in _orderitem_summary
  # def total_cost(cost)
  #   cost = @quantity * cost
  # return result
  # end
end
