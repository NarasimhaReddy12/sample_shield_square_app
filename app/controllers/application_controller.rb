class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	def call_shield_square
		if !session[:captcha_response].blank? && session[:captcha_response] == 1
			session[:captcha_response] = nil
			@shieldsquare_response = Ss2.shieldsquare_ValidateRequest("shield_square_user_name", 5, "", request, cookies)
		else
			@shieldsquare_call_type ||= 1
			@shieldsquare_response = Ss2.shieldsquare_ValidateRequest("shield_square_user_name", @shieldsquare_call_type, "", request, cookies)
		end
		if @shieldsquare_response.responsecode == 2
			session[:return_to] = request.request_uri
			redirect_to captcha_path
		end
	end
end
