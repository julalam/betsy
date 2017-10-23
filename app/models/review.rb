class Review < ApplicationRecord

  belongs_to :product

  validates :rating, presence: true
  validates :rating, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5, message: "Please enter a rating from 1 to 5" }
end
