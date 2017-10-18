class MerchantsController < ApplicationController

  def new
  end

  def create
  end

  def login
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def logout
  end
end
