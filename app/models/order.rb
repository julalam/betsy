class Order < ApplicationRecord
  validates :status, presence: true
  # :customer_name, :customer_email, :customer_address,
  # :cc_number,:cc_expiration, :cc_ccv,
  # :zip_code, presence: true

  has_many :products, through: :order_items 
end
