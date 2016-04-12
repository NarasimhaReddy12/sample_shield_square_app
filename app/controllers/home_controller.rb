class HomeController < ApplicationController

	before_filter :set_captcha_call_type, :only => [:captcha]
	before_filter :call_shield_square

	def captcha
		
	end
	def validate_captcha
		if verify_recaptcha
			session[:captcha_response] = 1
			call_shield_square
			session[:return_to] ? redirect_to(session[:return_to]) : redirect_to("/")
		else
			session[:captcha_response] = 2
			redirect_to captcha_path
		end
	end
private
	def set_captcha_call_type
		session[:captcha_response] = nil
		@shieldsquare_call_type = 4
	end
end