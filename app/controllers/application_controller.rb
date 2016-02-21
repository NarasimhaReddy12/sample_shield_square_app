class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	def call_shield_square
		@shieldsquare_call_type ||= 1
		@shieldsquare_response = Ss2.shieldsquare_ValidateRequest("shield_square_user_name", @shieldsquare_call_type, "", request, cookies)
		Rails.logger.debug "App Controller - #{@shieldsquare_response.inspect}"
		if @shieldsquare_response.responsecode == 2 || @captcha_response_code == 2
			session[:current_page] = request.path_info
			@shieldsquare_response = Ss2.shieldsquare_ValidateRequest("shield_square_user_name", 4, "", request, cookies)
			redirect_to captcha_path
		end
	end
end
