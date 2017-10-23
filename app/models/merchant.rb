class Merchant < ApplicationRecord
  has_many :products

  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: true

  def self.from_auth_hash(provider, auth_hash)
    merchant = new
    merchant.provider = provider
    merchant.uid = auth_hash['uid']
    merchant.email = auth_hash['info']['email']
    merchant.username = auth_hash['info']['nickname']
    return merchant
  end
end
