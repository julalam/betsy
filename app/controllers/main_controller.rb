class MainController < ApplicationController
  def index
    @products = Product.six_random_products
  end
end
