class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  before_action :require_login


  def render_404
    render :file => "#{Rails.root}/public/404.html", :status => 404
  end

  def require_login
    @merchant = Merchant.find_by(id: session[:merchant_id])
    unless @merchant
      flash[:status] = :failure
      flash[:notice] = "You must be logged in to do that"
      redirect_to root_path
    end
  end

private
  def allowed_user(merchant_id)
    merchant_id = merchant_id.to_i

    if  session[:merchant_id] != merchant_id
      flash[:status] = :failure
      flash[:message] = "Failure: You do cannot access account pages for other users"
      redirect_to root_path
      return false
    else
      return true
    end
  end


end
