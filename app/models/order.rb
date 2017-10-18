class Order < ApplicationRecord
  validates :status,
  :customer_name, :customer_email, :customer_address,
  :cc_number,:cc_expiration, :cc_ccv,
  :zip_code, presence: true
end
