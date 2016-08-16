class CommentsController < ApplicationController
	before_action :authenticate_user!
	def create
		@comentario = current_user.comments.new(parametros_de_comentario)
		set_content
		@comentario.creado = Time.now
		respond_to do |format|
			if @comentario.save
				format.html{ redirect_to @comentario.content, notice: "Comentario añadido"}
				format.json{ render :show, status: :created, notice: "Comentario añadido"}
			else
				format.html{render :new}
			end
		end
	end

	def set_content
		@contenido = Content.find(params[:content_id])
		@comentario.content = @contenido
	end

	protected

	def parametros_de_comentario
		params.require(:comment).permit(:user_id, :content_id, :cuerpo, :creado)
	end
end
