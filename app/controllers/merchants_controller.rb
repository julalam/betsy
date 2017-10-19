class MerchantsController < ApplicationController

  def login
    auth_hash = request.env['omniauth.auth']
    raise
  end

  def logout
  end
end
