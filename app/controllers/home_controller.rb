class HomeController < ApplicationController

	before_filter :set_response_code, :only => [:secure_page]
	before_filter :call_shield_square
	skip_before_filter :call_shield_square, :only => [:validate_captcha]

	def captcha
		session[:captcha_response] = nil
	end
	def secure_page
		
	end
	def validate_captcha
		if verify_recaptcha
			session[:captcha_response] = 1
			@shieldsquare_response = Ss2.shieldsquare_ValidateRequest("shield_square_user_name", 5, "", request, cookies)
			Rails.logger.debug "Home Controller - #{@shieldsquare_response.inspect}"
			redirect_to session[:current_page]
		else
			session[:captcha_response] = 2
			redirect_to captcha_path
		end
	end
private
	def set_response_code
		unless session[:captcha_response] == 1
			@captcha_response_code = 2
		end
	end
end