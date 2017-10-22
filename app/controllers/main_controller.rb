class MainController < ApplicationController
  skip_before_action :require_login

  def index
    @products = Product.six_random_products
  end
end
