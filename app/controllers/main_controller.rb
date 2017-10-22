class MainController < ApplicationController
  skip_before_action :require_login

  def index
    @products = Product.random_products(6)
  end
end
