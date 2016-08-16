class RatesController < ApplicationController
	before_action :authenticate_user!

	def create	
		if Rate.exists?(user_id: current_user.id, content_id: params[:content_id])
			@puntuacion = Rate.find_by(user_id: current_user.id, content_id: params[:content_id])
			@puntuacion.valor = Rate.new(parametros_de_puntaje).valor
		else
			@puntuacion = current_user.rates.new(parametros_de_puntaje)
			set_content
		end

		respond_to do |format|
			if @puntuacion.save
				format.html{ redirect_to @puntuacion.content}
				format.json{ render :show, status: :created, location: @puntuacion}
			else
				format.html{render :new}
			end
		end
	end



	def set_content
		@contenido = Content.find(params[:content_id])
		@puntuacion.content = @contenido
	end

	protected

	def parametros_de_puntaje
		params.require(:rate).permit(:user_id, :content_id, :valor)
	end
end
