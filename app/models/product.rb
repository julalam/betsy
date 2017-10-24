class Product < ApplicationRecord

  has_and_belongs_to_many :categories
  belongs_to :merchant
  has_many :reviews
  has_many :order_items
  has_many :orders, through: :order_items

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
  validates :price, numericality: { greater_than: 0 }


  def self.random_products(number)
    return Product.all.sample(number)
  end

  def self.new_products(number)
    return Product.all.order(:created_at).reverse.first(5)
  end

  def average_rating
    return reviews.average(:rating).to_i
  end

  def self.bestseller(number)
    return Product.all.sort_by { |product| -product.orders.count }.first(number)
  end

end
