class Merchant < ApplicationRecord
  has_many :products
  has_many :order_items, through: :products
  # has_many :orders, through: :products
  # has_many :orders, :through => :products


  def self.from_auth_hash(provider, auth_hash)
    merchant = new
    merchant.provider = provider
    merchant.uid = auth_hash['uid']
    merchant.email = auth_hash['info']['email']
    merchant.username = auth_hash['info']['nickname']

    return merchant
  end


end
