class ProductsController < ActionController::Base
	def create
		@captcha_response = RestClient.post 'https://www.google.com/recaptcha/api/siteverify', :secret => '6Ld23BYTAAAAAGB7qNtALl__niJ8S4z6TkX2aq6s', :response => params["g-recaptcha-response"]
		logger.debug @captcha_response
		render "layouts/application"
	end
	def index
		render "layouts/application"
	end
end