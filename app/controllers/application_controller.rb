class ApplicationController < ActionController::Base
  #protect_from_forgery with: :exception
  def login
  	unless user_signed_in? 
  		redirect_to '/users/sign_in'
  	end
  end
end
