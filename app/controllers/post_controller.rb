class PostController < ApplicationController
	def index
		unless params[:message].nil?
			@message = "소중한 의견 감사합니다."
		end
	end

	def create
		Post.create(content: params[:content],
					user_id: current_user.id)
		redirect_to '/post/index/complete'
	end
end
