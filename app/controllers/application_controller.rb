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

		if @shieldsquare_response.responsecode == 0
			logger.debug "Allow the user request"
		elsif @shieldsquare_response.responsecode == 1
      logger.debug "Monitor this Traffic"			
		elsif @shieldsquare_response.responsecode == 2
			if session[:captcha_response].blank? || session[:captcha_response] != 1
				session[:return_to] = request.url
				redirect_to captcha_path
			else
				session[:return_to] ? redirect_to(session[:return_to]) : redirect_to("/")
			end
    elsif @shieldsquare_response.responsecode == 3
    	logger.debug "Block This request"
    elsif @shieldsquare_response.responsecode == 4
      logger.debug "Feed Fake Data"			
    elsif @shieldsquare_response.responsecode == -1
      logger.debug "Please reach out to ShieldSquare support team for assistance <BR>"
      logger.debug "Allow the user request"      
		end		
	end
end
