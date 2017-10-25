class Merchant < ApplicationRecord
  has_many :products
  has_many :order_items, through: :products
  has_many :orders, through: :products
  # has_many :orders, :through => :products


  def self.from_auth_hash(provider, auth_hash)
    merchant = new
    merchant.provider = provider
    merchant.uid = auth_hash['uid']
    merchant.email = auth_hash['info']['email']
    merchant.username = auth_hash['info']['nickname']

    return merchant
  end

  def order_items_quantity
    sum = 0
    order_items.each do | order_item |
      sum += order_item.quantity
    end
    return sum
  end

  def order_items_total
    sum = 0
    order_items.each do | order_item |
      sum += order_item.total
    end
    return sum
  end

  def order_items_by_status(status)
    order_items = self.order_items.find_all { |order_item| order_item.order.status == status }
    return order_items
  end

  def self.number_of_items_sold(collection)
    return collection.inject(0) { |sum, order_item| sum + order_item.quantity }
  end

  def self.revenue_by_status(collection)
    return collection.inject(0) { |sum, order_item| sum + order_item.total }
  end

end
