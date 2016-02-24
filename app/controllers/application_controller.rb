class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	def call_shield_square
		if !session[:captcha_response].blank? && session[:captcha_response] == 1
			session[:captcha_response] = nil
			logger.debug "Call Type - #{Ss2::CAPTCHA_SUCCESS}"
			@shieldsquare_response = Ss2.shieldsquare_ValidateRequest("shield_square_user_name", Ss2::CAPTCHA_SUCCESS, "", request, cookies)
		else
			@shieldsquare_call_type ||= Ss2::PAGE_LOAD
			logger.debug "Call Type - #{@shieldsquare_call_type}"
			@shieldsquare_response = Ss2.shieldsquare_ValidateRequest("shield_square_user_name", @shieldsquare_call_type, "", request, cookies)
		end
		if @shieldsquare_response.responsecode == Ss2::SHIELDSQUARE_CODES_CAPTCHA
			session[:return_to] = request.request_uri
			redirect_to captcha_path
		end
	end
end
