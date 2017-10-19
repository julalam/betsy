class MerchantsController < ApplicationController

  def login
    auth_hash = request.env['omniauth.auth']

    if auth_hash['uid']
      merchant = Merchant.find_by(uid: auth_hash[:uid], provider: params[:provider])
      if merchant.nil?
        #merchant has not logged in before
        #create a new record
        merchant = Merchant.from_auth_hash(params[:provider], auth_hash)
        if merchant.save
          flash[:status] = :success
          flash[:notice] = "Logged in successfully as new merchant #{merchant.username}"
        else
          flash[:status] = :failure
          flash[:notice] = "Could not log in"
        end
      else
        flash[:status] = :success
        flash[:notice] = "Logged in successfully as existing merchant as #{merchant.username}"
      end
      session[:merchant_id] = merchant.id
    else
      flash[:status] = :failure
      flash[:notice] = "Could not log in"
    end
    redirect_to root_path
  end

  def logout
  end
end
