class Product < ApplicationRecord

  belongs_to :merchant
  has_many :order_item


  validates :name, presence: true, uniqueness: true
  validates :price, presence: true #must be a number too
  validates_numericality_of :price, greater_than: 0


end
