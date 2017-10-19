class Product < ApplicationRecord

  belongs_to :merchant
  has_many :order_item

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
  validates_numericality_of :price, greater_than: 0


  def self.three_random_products
    number = (Product.count)
    if number <= 3
      @rand_products = []
      Product.all.each do |product|
        @rand_products << product
      end
      return @rand_products
    end

    rand_index= []
    3.times do
      rand_number = rand(number)
      while rand_index.include?(rand_number)
        rand_number = rand(number)
      end
      rand_index << rand(number)
    end
    @rand_products =[]
    rand_index.each do |index|
      product = Product.all[index]
      unless product == nil
        @rand_products << Product.all[index]
      end
    end
    return @rand_products
  end

end
