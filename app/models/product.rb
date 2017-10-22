class Product < ApplicationRecord

  has_and_belongs_to_many :categories
  belongs_to :merchant
  has_many :order_item

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
  validates_numericality_of :price, greater_than: 0


  def self.random_products(number)
    return Product.all.sample(number)
  end

end
