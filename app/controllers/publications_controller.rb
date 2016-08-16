class PublicationsController < ApplicationController
	before_action :valida_nivel
	def index
		@contenido = Content.paginate(page: params[:page], per_page: 3).where(status: false)
	end
	def show
		@contenido = Content.paginate(page: params[:page], per_page: 3).where(status: false)
	end

	private
	def valida_nivel
		if !current_user || current_user.administration_id == 1
			redirect_to root_path, notice: "No Posees permisos para acceder!"
		end
	end
end
