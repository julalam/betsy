class MerchantsController < ApplicationController
  skip_before_action :require_login, only: [:login, :logout]

  def new
    @merchant = Merchant.new
  end

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
    if allowed_user(@merchant.id)
      @products = @merchant.products
    end
  end

  def login
    auth_hash = request.env['omniauth.auth']

    if auth_hash['uid']
      merchant = Merchant.find_by(uid: auth_hash[:uid], provider: params[:provider])
      if merchant.nil?
        merchant = Merchant.from_auth_hash(params[:provider], auth_hash)
        if merchant.save
          flash[:status] = :success
          flash[:message] = "Logged in successfully as new merchant #{merchant.username}"
        else
          flash[:status] = :failure
          flash[:message] = "Could not log in"
        end
      else
        if session[:merchant_id] == merchant.id
          flash[:status] = :failure
          flash[:message] = "You're already logged in"
        else
          flash[:status] = :success
          flash[:message] = "Logged in successfully as existing merchant as #{merchant.username}"
        end
      end
      session[:merchant_id] = merchant.id
    else
      flash[:status] = :failure
      flash[:message] = "Could not log in"
    end
    redirect_to root_path
  end

  def logout
    session[:merchant_id] = nil
    flash[:status] = :success
    flash[:message] = "Successfully logged out"
    redirect_to root_path
  end



end
