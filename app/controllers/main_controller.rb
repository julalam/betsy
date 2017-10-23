class MainController < ApplicationController
  skip_before_action :require_login

  def index
    @products = Product.random_products(6)
    @new_products = Product.new_products(5)
  end
end
