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

end
